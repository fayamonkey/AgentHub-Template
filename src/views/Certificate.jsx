import React, { useEffect, useState, useCallback } from "react";
import { supabase } from "../integrations/supabase/client";
import { loadVault } from "../lib/vault.js";
import { CONFIG } from "../config.js";
import { Icon } from "../lib/certIcons.jsx";

const HUB_TITLE = "My AI Hub Win";

function bodyLines(owner) {
  const who = owner && owner.trim() ? owner.trim() : "I";
  return [
    `${who} built an AgentHub, a command center to reduce AI overwhelm and focus on productivity.`,
    "The AgentHub is a remote control for agentic AI workers.",
  ];
}

function detectBadges({ cards, ideas, wins, changelog }) {
  const b = [];
  b.push({ key: "calm", icon: "badge-check", label: "Reduced AI overwhelm", desc: "One calm place instead of scattered tools." });
  b.push({ key: "hub", icon: "rocket", label: "AgentHub operator", desc: "Built and runs a private AI hub." });
  if (cards.length > 0) b.push({ key: "chain", icon: "link", label: "Three-tool chain", desc: "Lovable, GitHub and Cowork in one loop." });
  if (cards.some((c) => (c.fm && c.fm.schedule) || /briefing/i.test(c.file || ""))) b.push({ key: "auto", icon: "repeat", label: "Self-feeding automation", desc: "A scheduled task fills the hub on its own." });
  if (ideas > 0) b.push({ key: "ideas", icon: "lightbulb", label: "Ideas in motion", desc: ideas + " idea" + (ideas > 1 ? "s" : "") + " captured." });
  if (wins > 0) b.push({ key: "wins", icon: "trophy", label: "Wins shipped", desc: wins + " win" + (wins > 1 ? "s" : "") + " on the wall." });
  const lib = cards.filter((c) => ((c.fm && c.fm.category) || "").toLowerCase() === "library").length;
  if (lib > 0) b.push({ key: "library", icon: "book", label: "Library curator", desc: lib + " reference card" + (lib > 1 ? "s" : "") + " saved." });
  if (cards.some((c) => /cheat/i.test(c.file || "") || /cheat/i.test((c.fm && c.fm.title) || ""))) b.push({ key: "cheat", icon: "bookmark", label: "Hub cheat-sheet", desc: "Keeps a working reference on hand." });
  if (changelog > 0) b.push({ key: "log", icon: "history", label: "Changelog kept", desc: changelog + " entr" + (changelog > 1 ? "ies" : "y") + " logged." });
  if (cards.length >= 5) b.push({ key: "builder", icon: "rocket", label: "Hub builder", desc: cards.length + " cards live." });
  return b;
}

export default function Certificate() {
  const [cards, setCards] = useState([]);
  const [counts, setCounts] = useState({ ideas: 0, wins: 0, changelog: 0 });
  const [certs, setCerts] = useState([]);
  const [sel, setSel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [name, setName] = useState(CONFIG.ownerName || "");

  const loadCerts = useCallback(async () => {
    try {
      const { data } = await supabase.from("certificates").select("*").order("created_at", { ascending: false });
      setCerts(data || []);
      setSel((data && data[0]) || null);
    } catch { setCerts([]); }
  }, []);

  useEffect(() => {
    (async () => {
      setLoading(true);
      const v = await loadVault(CONFIG.githubRepo, CONFIG.vaultFolder).catch(() => []);
      setCards(v || []);
      const safeCount = async (t) => { try { const { count } = await supabase.from(t).select("*", { count: "exact", head: true }); return count || 0; } catch { return 0; } };
      setCounts({ ideas: await safeCount("ideas"), wins: await safeCount("wins"), changelog: await safeCount("changelog") });
      await loadCerts();
      setLoading(false);
    })();
  }, [loadCerts]);

  async function generate() {
    setBusy(true);
    const owner = (name || "").trim();
    const badges = detectBadges({ cards, ideas: counts.ideas, wins: counts.wins, changelog: counts.changelog });
    const row = { hub_name: "My AI Hub", owner_name: owner, badges, stats: { cards: cards.length, ...counts, citation: bodyLines(owner).join(" ") } };
    try {
      const { data } = await supabase.from("certificates").insert(row).select().single();
      if (data) { setCerts((c) => [data, ...c]); setSel(data); }
    } catch (e) { console.error("cert insert failed", e); }
    setBusy(false);
  }

  if (loading) return <div className="wrap"><div className="empty">Loading…</div></div>;

  const c = sel;
  const badges = c ? (c.badges || []) : [];
  const owner = c ? (c.owner_name || "") : "";
  const lines = bodyLines(owner);

  return (
    <div className="wrap">
      <div className="hello">Your achievement</div>
      <h1>My AI Hub Win</h1>
      <p className="sub">A shareable snapshot of what your hub is and what it does. Generate one anytime and post it anywhere.</p>

      <div className="cert-actions">
        <input
          className="cert-name-field"
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Your name (optional)"
          maxLength={48}
          onKeyDown={(e) => { if (e.key === "Enter" && !busy) generate(); }}
        />
        <button className="btn-primary" onClick={generate} disabled={busy}>
          {busy ? "Generating…" : (certs.length ? "Generate a new one" : "Generate your Win card")}
        </button>
      </div>

      {!c ? (
        <div className="empty">No Win card yet. Press the button to mint your first one.</div>
      ) : (
        <div className="cert-win">
          <div className="cert-win-mark"><img src="/brand/aia-icon.png" alt="" width="70" height="70" /></div>
          <img className="cert-win-brand" src="/brand/aia-logo-white.png" alt="AI Advantage" />
          <div className="cert-win-title">{HUB_TITLE}</div>

          <div className="cert-win-body">
            {lines.map((ln, i) => <p key={i}>{ln}</p>)}
          </div>

          <div className="cert-win-cap">
            <span className="cert-win-cap-rule" />
            <span className="cert-win-cap-pill">Capabilities unlocked</span>
            <span className="cert-win-cap-rule" />
          </div>

          <div className="cert-win-badges">
            {badges.map((b, i) => (
              <div key={i} className="cert-win-badge" title={b.desc}>
                <span className="cert-win-badge-ico"><Icon name={b.icon} size={16} /></span>
                <span className="cert-win-badge-l">{b.label}</span>
              </div>
            ))}
          </div>

          <div className="cert-win-foot">
            {new Date(c.created_at).toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" })}
          </div>
        </div>
      )}

      {certs.length > 1 && (
        <div className="cert-gallery">
          <div className="cert-gallery-head">Your Win cards</div>
          <div className="cert-gallery-row">
            {certs.map((x) => (
              <button key={x.id} className={`cert-thumb${sel && sel.id === x.id ? " on" : ""}`} onClick={() => setSel(x)}>
                <Icon name="trophy" size={15} />
                <span>{new Date(x.created_at).toLocaleDateString()}</span>
                <span className="cert-thumb-n">{(x.badges || []).length} badges</span>
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
