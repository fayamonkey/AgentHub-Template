import { corsHeaders } from 'npm:@supabase/supabase-js@2/cors';

const TOKEN = Deno.env.get('GITHUB_VAULT_TOKEN')!;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  try {
    const { repo, folder = 'content', content, source = 'typed' } = await req.json();
    if (!repo || !content || !String(content).trim()) {
      return new Response(JSON.stringify({ error: 'repo and content are required' }), {
        status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    const now = new Date();
    const ts = now.toISOString().replace(/[:.]/g, '-');
    const day = now.toISOString().slice(0, 10);
    const path = `${folder}/braindump-${ts}.md`;
    const preview = String(content).trim().replace(/\s+/g, ' ').slice(0, 48);
    const file =
`---
title: 🌀 ${preview || 'New braindump'}
emoji: 🧠
category: braindump
status: pending
source: ${source}
updated: ${day}
---
${content}
`;
    const b64 = btoa(unescape(encodeURIComponent(file)));
    const res = await fetch(`https://api.github.com/repos/${repo}/contents/${path.split('/').map(encodeURIComponent).join('/')}`, {
      method: 'PUT',
      headers: {
        Authorization: `Bearer ${TOKEN}`,
        Accept: 'application/vnd.github.v3+json',
        'User-Agent': 'lovable-hub',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ message: `braindump: capture ${ts}`, content: b64 }),
    });
    if (!res.ok) {
      const t = await res.text();
      return new Response(JSON.stringify({ error: `GitHub ${res.status}: ${t}` }), {
        status: 502, headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }
    return new Response(JSON.stringify({ ok: true, path }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
