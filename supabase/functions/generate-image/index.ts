import { corsHeaders } from 'npm:@supabase/supabase-js@2/cors';
import { createClient } from 'npm:@supabase/supabase-js@2';

const LOVABLE_API_KEY = Deno.env.get('LOVABLE_API_KEY');
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const BUCKET = 'hub-images';

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

function extractImage(data: any): string | null {
  try {
    const m = data?.choices?.[0]?.message;
    if (m?.images?.[0]?.image_url?.url) return m.images[0].image_url.url;
    if (typeof m?.content === 'string' && m.content.startsWith('data:image')) return m.content;
    if (Array.isArray(m?.content)) {
      const im = m.content.find((c: any) => c?.image_url?.url);
      if (im) return im.image_url.url;
    }
    if (data?.data?.[0]?.b64_json) return 'data:image/png;base64,' + data.data[0].b64_json;
    if (data?.data?.[0]?.url) return data.data[0].url;
  } catch (_) {}
  return null;
}

function dataUrlToBytes(dataUrl: string) {
  const comma = dataUrl.indexOf(',');
  const meta = dataUrl.slice(0, comma);
  const b64 = dataUrl.slice(comma + 1);
  const contentType = (meta.match(/data:(.*?);base64/) || [])[1] || 'image/png';
  const bin = atob(b64);
  const bytes = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
  return { bytes, contentType };
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  try {
    if (!LOVABLE_API_KEY) return json({ error: 'AI is not enabled on this project yet. Enable Lovable AI, then try again.' }, 400);
    const { prompt, model, ratio, presetId, instructions, referenceImages } = await req.json();
    if (!prompt || !String(prompt).trim()) return json({ error: 'Please enter a prompt.' }, 400);

    const useModel = (model && String(model).trim()) || 'google/gemini-2.5-flash-image';
    const ratioText = ratio ? ` Aspect ratio ${ratio}.` : '';
    const fullText = (instructions ? String(instructions).trim() + '\n\n' : '') + String(prompt).trim() + ratioText;

    const refs: string[] = Array.isArray(referenceImages) ? referenceImages.filter(Boolean) : [];

    // OpenAI image models on the Lovable AI Gateway do NOT accept reference images.
    // If refs are attached, auto-route to a Gemini image model that does.
    let effectiveModel = useModel;
    if (refs.length && !effectiveModel.startsWith('google/')) {
      effectiveModel = 'google/gemini-2.5-flash-image';
    }
    const isGemini = effectiveModel.startsWith('google/');

    let aiResp: Response;
    if (isGemini) {
      // Gemini image models go through chat completions with modalities=['image','text'].
      aiResp = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
        method: 'POST',
        headers: { Authorization: `Bearer ${LOVABLE_API_KEY}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({
          model: effectiveModel,
          messages: [{
            role: 'user',
            content: refs.length
              ? [{ type: 'text', text: fullText }, ...refs.map((u) => ({ type: 'image_url', image_url: { url: u } }))]
              : fullText,
          }],
          modalities: ['image', 'text'],
        }),
      });
    } else {
      // OpenAI image models use the dedicated images endpoint and do NOT support refs.
      aiResp = await fetch('https://ai.gateway.lovable.dev/v1/images/generations', {
        method: 'POST',
        headers: { Authorization: `Bearer ${LOVABLE_API_KEY}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({ model: effectiveModel, prompt: fullText, n: 1 }),
      });
    }

    if (!aiResp.ok) {
      const detail = (await aiResp.text()).slice(0, 400);
      const msg =
        aiResp.status === 429 ? 'Rate limit reached. Wait a moment and try again.' :
        aiResp.status === 402 ? 'You are out of AI credits. Top up in Lovable: Settings -> Cloud & AI balance.' :
        `Image generation failed (${aiResp.status}).`;
      return json({ error: msg, detail }, aiResp.status);
    }

    const data = await aiResp.json();
    const dataUrl = extractImage(data);
    if (!dataUrl) return json({ error: 'The model did not return an image. Try another model or rephrase.', detail: JSON.stringify(data).slice(0, 400) }, 502);

    const supa = createClient(SUPABASE_URL, SERVICE_ROLE);
    let url = dataUrl;
    let storage_path: string | null = null;

    if (dataUrl.startsWith('data:')) {
      const { bytes, contentType } = dataUrlToBytes(dataUrl);
      const ext = contentType.includes('jpeg') ? 'jpg' : contentType.includes('webp') ? 'webp' : 'png';
      storage_path = `${crypto.randomUUID()}.${ext}`;
      const up = await supa.storage.from(BUCKET).upload(storage_path, bytes, { contentType, upsert: false });
      if (up.error) return json({ error: 'Image generated, but saving it failed: ' + up.error.message }, 500);
      const signed = await supa.storage.from(BUCKET).createSignedUrl(storage_path, 60 * 60 * 24 * 365 * 10);
      url = signed.data?.signedUrl || url;
    }

    const ins = await supa.from('images').insert({
      prompt: String(prompt).trim(), model: effectiveModel, ratio: ratio || null,
      preset_id: presetId || null, storage_path, url,
    }).select().single();

    return json({ ok: true, image: ins.data || { url, prompt, model: effectiveModel, ratio } });
  } catch (e) {
    return json({ error: String((e as Error)?.message || e) }, 500);
  }
});
