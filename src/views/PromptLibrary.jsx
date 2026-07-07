import React, { useEffect, useMemo, useState } from "react";
import { supabase } from "../integrations/supabase/client";
import library from "../data/promptLibrary.json";
import "./PromptLibrary.css";

const KINDS = [
  { id: "all", label: "All", emoji: "✦" },
  { id: "prompt", label: "Prompts", emoji: "✍️" },
  { id: "follow-up", label: "Follow-ups", emoji: "🔁" },
  { id: "style", label: "Styles", emoji: "🎭" },
];
const kindMeta = (k) => KINDS.find((x) => x.id === k) || KINDS[0];
const copyText = (p) =>
  p.kind === "style" ? `Write in the style of ${p.title} — ${p.text}` : (p.text || p.formula || p.title);

export default function PromptLibrary() {
  const [rows, setRows] = useState(null); // null = loading
  const [q, setQ] = useState("");
  const [kind, setKind] = useState("all");
  const [cat, setCat] = useState("all");
  const [favOnly, setFavOnly] = useState(false);
  const [open, setOpen] = useState(null);
  const [adding, setAdding] = useState(false);
  const [copied, setCopied] = useState(null);
  const [form, setForm] = useState({ title: "", category: "", kind: "prompt", text: "", formula: "" });

  async function load() {
    try {
      const { data, error } = await supabase
        .from("prompts")
        .select("*")
        .order("favorite", { ascending: false })
        .order("created_at", { ascending: false });
      if (error) throw error;
      const db = data || [];
      const seeded = db.some((d) => d.source === "library");
      if (seeded) {
        setRows(db.map((d) => ({ ...d, mine: d.source !== "library" })));
      } else {
        const userRows = db.filter((d) => d.source !== "library").map((d) => ({ ...d, mine: true }));
        setRows([...userRows, ...library.map((d) => ({ ...d, mine: false }))]);
      }
    } catch {
      setRows(library.map((d) => ({ ...d, mine: false })));
    }
  }
  useEffect(() => { load(); }, []);

  const all = useMemo(() => rows || [], [rows]);

  const counts = useMemo(() => {
    const c = { all: all.length, prompt: 0, "follow-up": 0, style: 0 };
    all.forEach((p) => { c[p.kind] = (c[p.kind] || 0) + 1; });
    return c;
  }, [all]);

  const categories = useMemo(() => {
    const map = new Map();
    all.forEach((p) => {
      if (kind !== "all" && p.kind !== kind) return;
      const k = p.category || "General";
      map.set(k, (map.get(k) || 0) + 1);
    });
    return ["all", ...[...map.keys()].sort((a, b) => a.localeCompare(b))];
  }, [all, kind]);

  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase();
    return all.filter((p) => {
      if (kind !== "all" && p.kind !== kind) return false;
      if (cat !== "all" && (p.category || "General") !== cat) return false;
      if (favOnly && !p.favorite) return false;
      if (needle) {
        const hay = `${p.title} ${p.category} ${p.text} ${p.formula || ""}`.toLowerCase();
        if (!hay.includes(needle)) return false;
      }
      return true;
    });
  }, [all, q, kind, cat, favOnly]);

  function copy(p, e) {
    if (e) e.stopPropagation();
    navigator.clipboard.writeText(copyText(p));
    setCopied(p.id); setTimeout(() => setCopied(null), 1300);
  }

  async function addPrompt() {
    if (!form.title.trim() && !form.text.trim()) return;
    try {
      await supabase.from("prompts").insert({
        title: form.title.trim() || "(untitled)",
        category: form.category.trim() || "General",
        kind: form.kind,
        text: form.text.trim(),
        formula: form.formula.trim(),
      });
    } catch {}
    setAdding(false);
    setForm({ title: "", category: "", kind: "prompt", text: "", formula: "" });
    load();
  }

  async function deletePrompt(p) {
    if (!p.mine) return;
    if (!confirm(`Delete your prompt "${p.title}"?`)) return;
    try { await supabase.from("prompts").delete().eq("id", p.id); } catch {}
    setOpen(null); load();
  }

  return (
    <div className="pl">
      {/* Top navigation — works on mobile (chips scroll horizontally) */}
      <nav className="pl-nav">
        <div className="pl-search">
          <span>🔍</span>
          <input placeholder="Search by keyword, tag or wording…" value={q} onChange={(e) => setQ(e.target.value)} />
          {q && <button className="pl-clear" onClick={() => setQ("")}>×</button>}
        </div>

        <div className="pl-tabs">
          {KINDS.map((k) => (
            <button key={k.id} className={`pl-tab${kind === k.id ? " active" : ""}`}
              onClick={() => { setKind(k.id); setCat("all"); }}>
              <span>{k.emoji}</span> {k.label} <em>{counts[k.id] ?? 0}</em>
            </button>
          ))}
          <button className={`pl-tab pl-fav${favOnly ? " active" : ""}`} onClick={() => setFavOnly((v) => !v)}>★ Favorites</button>
        </div>

        <div className="pl-cats">
          {categories.map((c) => (
            <button key={c} className={`pl-catchip${cat === c ? " active" : ""}`} onClick={() => setCat(c)}>
              {c === "all" ? "All categories" : c}
            </button>
          ))}
        </div>
      </nav>

      <header className="pl-hero">
        <div className="pl-hero-txt">
          <div className="pl-eyebrow">Prompt Library</div>
          <h1>{counts.all} prompts, styles &amp; follow-ups</h1>
          <p>Search everything, copy in one click, or add your own — yours travel with your hub.</p>
        </div>
        <button className="pl-add-btn" onClick={() => setAdding(true)}>＋ Add prompt</button>
      </header>

      <div className="pl-count">{filtered.length} result{filtered.length !== 1 ? "s" : ""}</div>

      {rows === null ? (
        <div className="pl-empty">Loading library…</div>
      ) : filtered.length === 0 ? (
        <div className="pl-empty">Nothing matches your filters.</div>
      ) : (
        <div className="pl-grid">
          {filtered.slice(0, 400).map((p) => (
            <button key={p.id} className={`pl-card pl-k-${p.kind}`} onClick={() => setOpen(p)}>
              <div className="pl-card-top">
                <span className="pl-kbadge">{kindMeta(p.kind).emoji} {kindMeta(p.kind).label.replace(/s$/, "")}</span>
                {p.mine && <span className="pl-mine">yours</span>}
                {p.favorite && <span className="pl-star">★</span>}
              </div>
              <div className="pl-card-title">{p.title}</div>
              <div className="pl-card-cat">{p.category}</div>
              <div className="pl-card-text">{p.text}</div>
              <div className="pl-card-foot">
                <span className="pl-copy" onClick={(e) => copy(p, e)}>{copied === p.id ? "✓ Copied" : "📋 Copy"}</span>
              </div>
            </button>
          ))}
          {filtered.length > 400 && <div className="pl-more">Showing first 400 — refine your search to see more.</div>}
        </div>
      )}

      {open && (
        <div className="pl-modal" onClick={(e) => e.target.className === "pl-modal" && setOpen(null)}>
          <div className="pl-panel">
            <div className="pl-panel-head">
              <button className="pl-x" onClick={() => setOpen(null)}>×</button>
              <div className="pl-kbadge">{kindMeta(open.kind).emoji} {kindMeta(open.kind).label.replace(/s$/, "")}</div>
              {open.favorite && <span className="pl-star">★ favorite</span>}
              {open.mine && <span className="pl-mine">yours</span>}
            </div>
            <div className="pl-panel-body">
              <div className="pl-eyebrow">{open.category}</div>
              <h2>{open.title}</h2>
              {open.kind === "style" ? (
                <>
                  <div className="pl-label">Effect</div>
                  <p className="pl-text">{open.text}</p>
                  <div className="pl-label">Copy-ready</div>
                  <pre className="pl-pre">{copyText(open)}</pre>
                </>
              ) : (
                <>
                  <div className="pl-label">Example</div>
                  <pre className="pl-pre">{open.text}</pre>
                  {open.formula && (
                    <>
                      <div className="pl-label">Formula (fill the [blanks])</div>
                      <pre className="pl-pre pl-formula">{open.formula}</pre>
                    </>
                  )}
                </>
              )}
              <div className="pl-panel-actions">
                <button className="pl-add-btn" onClick={(e) => copy(open, e)}>{copied === open.id ? "✓ Copied" : "📋 Copy prompt"}</button>
                {open.mine && <button className="pl-del" onClick={() => deletePrompt(open)}>Delete</button>}
              </div>
            </div>
          </div>
        </div>
      )}

      {adding && (
        <div className="pl-modal" onClick={(e) => e.target.className === "pl-modal" && setAdding(false)}>
          <div className="pl-panel">
            <div className="pl-panel-head">
              <button className="pl-x" onClick={() => setAdding(false)}>×</button>
              <div className="pl-kbadge">＋ New prompt</div>
            </div>
            <div className="pl-panel-body">
              <div className="pl-form">
                <label>Title
                  <input value={form.title} autoFocus onChange={(e) => setForm({ ...form, title: e.target.value })} /></label>
                <div className="pl-form-row">
                  <label>Type
                    <select value={form.kind} onChange={(e) => setForm({ ...form, kind: e.target.value })}>
                      <option value="prompt">Prompt</option>
                      <option value="follow-up">Follow-up</option>
                      <option value="style">Style</option>
                    </select></label>
                  <label>Category
                    <input placeholder="e.g. Marketing" value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} /></label>
                </div>
                <label>Prompt text
                  <textarea rows={6} value={form.text} onChange={(e) => setForm({ ...form, text: e.target.value })} /></label>
                <label>Formula <span className="pl-hint">(optional — use [brackets] for blanks)</span>
                  <textarea rows={3} value={form.formula} onChange={(e) => setForm({ ...form, formula: e.target.value })} /></label>
                <div className="pl-panel-actions">
                  <button className="pl-add-btn" onClick={addPrompt}>Add to library</button>
                  <button className="pl-del" onClick={() => setAdding(false)}>Cancel</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
