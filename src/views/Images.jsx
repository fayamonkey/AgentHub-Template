import React, { useEffect, useRef, useState, useCallback } from "react";
import { supabase } from "../integrations/supabase/client";

// Curated list of Lovable AI image models (gateway slugs). Easy to update as Lovable's list changes.
const MODELS = [
  { slug: "google/gemini-2.5-flash-image", label: "Gemini 2.5 Flash Image — supports logos/references ⭐" },
  { slug: "google/gemini-3-pro-image-preview", label: "Gemini 3 Pro Image (Nano Banana Pro) — supports logos" },
  { slug: "google/gemini-3-flash-image-preview", label: "Gemini 3 Flash Image (Nano Banana 2) — supports logos" },
  { slug: "openai/gpt-image-2", label: "GPT Image 2 — text-to-image only (no logos)" },
  { slug: "openai/gpt-image-1-mini", label: "GPT Image 1 Mini — text-to-image only (no logos)" },
]
const RATIOS = ["1:1", "16:9", "9:16", "4:3", "3:4", "3:2", "2:3"];

const LS = "hub-images-defaults";
function loadDefaults() {
  try { return JSON.parse(localStorage.getItem(LS)) || {}; } catch { return {}; }
}

function fileToDataUrl(file) {
  return new Promise((res, rej) => {
    const r = new FileReader();
    r.onload = () => res(r.result);
    r.onerror = rej;
    r.readAsDataURL(file);
  });
}

export default function Images() {
  const defaults = loadDefaults();
  const [presets, setPresets] = useState([]);
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  const [active, setActive] = useState(null); // active preset object or null
  const [model, setModel] = useState(defaults.model || MODELS[0].slug);
  const [ratio, setRatio] = useState(defaults.ratio || "1:1");
  const [prompt, setPrompt] = useState("");
  const [refs, setRefs] = useState([]); // ad-hoc reference images (data URLs)

  const [editor, setEditor] = useState(null); // preset being created/edited
  const [viewer, setViewer] = useState(null); // image opened in lightbox
  const refInput = useRef(null);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [p, i] = await Promise.all([
        supabase.from("image_presets").select("*").order("created_at", { ascending: false }),
        supabase.from("images").select("*").order("created_at", { ascending: false }),
      ]);
      setPresets(p.data || []);
      setImages(i.data || []);
    } catch (e) { setError(String(e.message || e)); }
    setLoading(false);
  }, []);

  useEffect(() => { load(); }, [load]);
  useEffect(() => { localStorage.setItem(LS, JSON.stringify({ model, ratio })); }, [model, ratio]);

  function applyPreset(p) {
    setActive(p);
    if (p.model) setModel(p.model);
    if (p.ratio) setRatio(p.ratio);
    setError(null);
  }
  function clearPreset() { setActive(null); }

  async function addRefs(fileList) {
    const files = Array.from(fileList || []).slice(0, 5);
    const urls = await Promise.all(files.map(fileToDataUrl));
    setRefs((r) => [...r, ...urls].slice(0, 6));
  }

  async function generate() {
    if (!prompt.trim() || busy) return;
    setBusy(true); setError(null);
    const referenceImages = [
      ...((active && active.reference_images) || []),
      ...refs,
    ];
    try {
      const { data, error: err } = await supabase.functions.invoke("generate-image", {
        body: {
          prompt: prompt.trim(),
          model,
          ratio,
          presetId: active ? active.id : null,
          instructions: active ? active.instructions || "" : "",
          referenceImages,
        },
      });
      if (err) throw new Error(err.message || "Edge function unreachable");
      if (data?.error) throw new Error(data.error);
      if (data?.image) { setImages((arr) => [data.image, ...arr]); setPrompt(""); }
    } catch (e) {
      setError(String(e.message || e));
    } finally { setBusy(false); }
  }

  async function download(img) {
    try {
      const r = await fetch(img.url, { mode: "cors" });
      const blob = await r.blob();
      const a = document.createElement("a");
      a.href = URL.createObjectURL(blob);
      a.download = `hub-image-${(img.id || Date.now())}.png`;
      a.click();
      setTimeout(() => URL.revokeObjectURL(a.href), 4000);
    } catch {
      window.open(img.url, "_blank", "noopener");
    }
  }

  async function deleteImage(img) {
    if (!confirm("Delete this image?")) return;
    setImages((arr) => arr.filter((x) => x.id !== img.id));
    setViewer(null);
    try {
      if (img.storage_path) await supabase.storage.from("hub-images").remove([img.storage_path]);
      if (img.id) await supabase.from("images").delete().eq("id", img.id);
    } catch { /* ignore */ }
  }

  return (
    <div className="wrap img-wrap">
      <div className="hello">Create with AI</div>
      <h1>🎨 Images</h1>
      <p className="sub">Generate images with Lovable AI. Saved presets remember your style and brand. Uses your Lovable AI credits.</p>

      <div className="img-layout">
        {/* ---- Presets sidebar (customGPTs for images) ---- */}
        <aside className="img-side">
          <div className="img-side-head">
            <span>Presets</span>
            <button className="img-mini" onClick={() => setEditor({ name: "", emoji: "✨", instructions: "", model, ratio, reference_images: [] })}>+ New</button>
          </div>
          <p className="img-side-hint">A preset is your own image assistant: its own instructions, model, ratio and brand images. Pick one to preload it.</p>
          <button className={`img-preset${!active ? " on" : ""}`} onClick={clearPreset}>
            <span className="img-preset-emoji">🆓</span>
            <span className="img-preset-name">Free generate</span>
          </button>
          {presets.map((p) => (
            <div key={p.id} className={`img-preset${active && active.id === p.id ? " on" : ""}`} onClick={() => applyPreset(p)}>
              <span className="img-preset-emoji">{p.emoji || "✨"}</span>
              <span className="img-preset-name">{p.name}</span>
              <button className="img-preset-edit" title="Edit" onClick={(e) => { e.stopPropagation(); setEditor({ ...p }); }}>✎</button>
            </div>
          ))}
        </aside>

        {/* ---- Composer ---- */}
        <section className="img-main">
          <div className="img-composer">
            {active && (
              <div className="img-activechip">
                <span>{active.emoji || "✨"} {active.name}</span>
                <button onClick={clearPreset} title="Clear preset">×</button>
              </div>
            )}
            <div className="img-controls">
              <label>Model
                <select value={model} onChange={(e) => setModel(e.target.value)}>
                  {MODELS.map((m) => <option key={m.slug} value={m.slug}>{m.label}</option>)}
                </select>
              </label>
              <label>Ratio
                <select value={ratio} onChange={(e) => setRatio(e.target.value)}>
                  {RATIOS.map((r) => <option key={r} value={r}>{r}</option>)}
                </select>
              </label>
              <button className="img-ref-btn" onClick={() => refInput.current?.click()} title="Add a logo or reference image">＋ Reference</button>
              <input ref={refInput} type="file" accept="image/*" multiple hidden onChange={(e) => addRefs(e.target.files)} />
            </div>

            {(refs.length > 0 || (active && (active.reference_images || []).length > 0)) && (
              <div className="img-refs">
                {(active?.reference_images || []).map((u, i) => <div key={"p" + i} className="img-ref"><img src={u} alt="" /><span className="img-ref-tag">preset</span></div>)}
                {refs.map((u, i) => (
                  <div key={i} className="img-ref"><img src={u} alt="" /><button onClick={() => setRefs((r) => r.filter((_, j) => j !== i))}>×</button></div>
                ))}
              </div>
            )}

            <textarea
              className="img-prompt"
              rows={3}
              placeholder={active ? "Describe this specific image. Your preset's style and brand are already applied." : "Describe the image you want..."}
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
              onKeyDown={(e) => { if ((e.metaKey || e.ctrlKey) && e.key === "Enter") generate(); }}
            />
            <div className="img-gen-row">
              <button className="btn-primary" onClick={generate} disabled={busy || !prompt.trim()}>
                {busy ? "Generating…" : "Generate"}
              </button>
              <span className="img-hint">Cmd/Ctrl + Enter</span>
              {error && <span className="img-err">{error}</span>}
            </div>
          </div>

          {/* ---- Gallery ---- */}
          <div className="img-gallery-head">{images.length > 0 ? `${images.length} creation${images.length > 1 ? "s" : ""}` : "Your gallery"}</div>
          {loading ? (
            <div className="empty">Loading…</div>
          ) : images.length === 0 ? (
            <div className="empty">No images yet. Write a prompt and hit Generate.</div>
          ) : (
            <div className="img-grid">
              {images.map((img) => (
                <figure key={img.id || img.url} className="img-card" onClick={() => setViewer(img)}>
                  <img src={img.url} alt={img.prompt} loading="lazy" />
                  <figcaption>{img.prompt}</figcaption>
                </figure>
              ))}
            </div>
          )}
        </section>
      </div>

      {/* ---- Lightbox ---- */}
      {viewer && (
        <div className="modal" onClick={(e) => e.target.className === "modal" && setViewer(null)}>
          <div className="panel img-viewer">
            <button className="x" onClick={() => setViewer(null)}>×</button>
            <img src={viewer.url} alt={viewer.prompt} />
            <div className="img-viewer-meta">
              <p>{viewer.prompt}</p>
              <div className="img-viewer-tags">
                {viewer.model && <span className="tr-tag">{viewer.model}</span>}
                {viewer.ratio && <span className="tr-tag">{viewer.ratio}</span>}
              </div>
              <div className="formrow">
                <button className="btn-primary" onClick={() => download(viewer)}>⬇ Download</button>
                <button className="btn-danger" onClick={() => deleteImage(viewer)}>Delete</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ---- Preset editor ---- */}
      {editor && <PresetEditor editor={editor} setEditor={setEditor} onSaved={load} />}
    </div>
  );
}

function PresetEditor({ editor, setEditor, onSaved }) {
  const [p, setP] = useState(editor);
  const [saving, setSaving] = useState(false);
  const fileRef = useRef(null);
  const isEdit = !!p.id;

  async function addLogo(fileList) {
    const files = Array.from(fileList || []).slice(0, 4);
    const urls = await Promise.all(files.map(fileToDataUrl));
    setP((x) => ({ ...x, reference_images: [...(x.reference_images || []), ...urls].slice(0, 4) }));
  }

  async function save() {
    if (!p.name.trim()) return;
    setSaving(true);
    const row = {
      name: p.name.trim(), emoji: p.emoji || "✨", instructions: p.instructions || "",
      model: p.model || null, ratio: p.ratio || null, reference_images: p.reference_images || [],
    };
    try {
      const { error } = isEdit
        ? await supabase.from("image_presets").update(row).eq("id", p.id)
        : await supabase.from("image_presets").insert(row);
      if (error) throw new Error(error.message);
      setEditor(null);
      onSaved();
    } catch (e) {
      alert("Could not save the preset: " + (e.message || e) + "\n\nIf this says the table is missing, ask Lovable to apply the Images migration.");
    }
    setSaving(false);
  }
  async function remove() {
    if (!isEdit || !confirm("Delete this preset?")) return;
    try { await supabase.from("image_presets").delete().eq("id", p.id); setEditor(null); onSaved(); }
    catch (e) { alert(e.message || e); }
  }

  return (
    <div className="modal" onClick={(e) => e.target.className === "modal" && setEditor(null)}>
      <div className="panel">
        <button className="x" onClick={() => setEditor(null)}>×</button>
        <h2 style={{ marginTop: 0 }}>{isEdit ? "Edit preset" : "New image preset"}</h2>
        <div className="formgrid">
          <div className="formrow" style={{ gap: 8 }}>
            <label style={{ width: 64 }}>Emoji<input value={p.emoji || ""} maxLength={2} onChange={(e) => setP({ ...p, emoji: e.target.value })} /></label>
            <label style={{ flex: 1 }}>Name<input value={p.name} placeholder="e.g. My Brand Images" onChange={(e) => setP({ ...p, name: e.target.value })} autoFocus /></label>
          </div>
          <label>Instructions (the style/context it should always use)
            <textarea rows={5} value={p.instructions || ""} placeholder="e.g. Always use my brand colors (deep navy + gold), clean and minimal, lots of negative space. Put my logo bottom-right. Never use stock-photo people." onChange={(e) => setP({ ...p, instructions: e.target.value })} />
          </label>
          <div className="formrow" style={{ gap: 8 }}>
            <label style={{ flex: 1 }}>Default model
              <select value={p.model || ""} onChange={(e) => setP({ ...p, model: e.target.value })}>
                <option value="">(composer default)</option>
                {MODELS.map((m) => <option key={m.slug} value={m.slug}>{m.label}</option>)}
              </select>
            </label>
            <label style={{ width: 110 }}>Ratio
              <select value={p.ratio || ""} onChange={(e) => setP({ ...p, ratio: e.target.value })}>
                <option value="">(default)</option>
                {RATIOS.map((r) => <option key={r} value={r}>{r}</option>)}
              </select>
            </label>
          </div>
          <label>Brand / reference images (logo etc., composited into generations)
            <div className="img-refs">
              {(p.reference_images || []).map((u, i) => (
                <div key={i} className="img-ref"><img src={u} alt="" /><button onClick={() => setP({ ...p, reference_images: p.reference_images.filter((_, j) => j !== i) })}>×</button></div>
              ))}
              <button className="img-ref-add" onClick={() => fileRef.current?.click()}>＋</button>
              <input ref={fileRef} type="file" accept="image/*" multiple hidden onChange={(e) => addLogo(e.target.files)} />
            </div>
          </label>
          <div className="formrow">
            <button className="btn-primary" onClick={save} disabled={saving || !p.name.trim()}>{saving ? "Saving…" : "Save preset"}</button>
            <button className="btn-ghost" onClick={() => setEditor(null)}>Cancel</button>
            {isEdit && <button className="btn-danger" onClick={remove}>Delete</button>}
          </div>
        </div>
      </div>
    </div>
  );
}
