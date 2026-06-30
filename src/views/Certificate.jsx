import React, { useEffect, useState, useCallback } from "react";
import { supabase } from "../integrations/supabase/client";
import { loadVault } from "../lib/vault.js";
import { CONFIG } from "../config.js";
import { Icon } from "../lib/certIcons.jsx";

const SIGNATORIES = ["Igor", "Dean", "Tony"];

function detectBadges({ cards, ideas, wins, changelog }) {
  const b = [];
  b.push({ key: "hub", icon: "badge-check", label: "AgentHub Operator", desc: "Built and runs a private AI hub." });
  if (cards.length > 0) b.push({ key: "chain", icon: "link", label: "Three-Tool Chain", desc: "Lovable, GitHub and Cowork in one loop." });
  if (cards.some((c) => (c.fm && c.fm.schedule) || /briefing/i.test(c.file || ""))) b.push({ key: "auto", icon: "repeat", label: "Self-Feeding Automation", desc: "A scheduled task fills the hub on its own." });
  if (cards.some((c) => /cheat/i.test(c.file || "") || /cheat/i.test((c.fm && c.fm.title) || ""))) b.push({ key: "cheat", icon: "bookmark", label: "Hub Cheat-Sheet", desc: "Keeps a working reference on hand." });
  const lib = cards.filter((c) => ((c.fm && c.fm.category) || "").toLowerCase() === "library").length;
  if (lib > 0) b.push({ key: "library", icon: "book", label: "Library Curator", desc: lib + " reference card" + (lib > 1 ? "s" : "") + " saved." });
  if (ideas > 0) b.push({ key: "ideas", icon: "lightbulb", label: "Ideas in Motion", desc: ideas + " idea" + (ideas > 1 ? "s" : "") + " captured." });
  if (wins > 0) b.push({ key: "wins", icon: "trophy", label: "Wins Shipped", desc: wins + " win" + (wins > 1 ? "s" : "") + " on the wall." });
  if (changelog > 0) b.push({ key: "log", icon: "history", label: "Changelog Keeper", desc: changelog + " entr" + (changelog > 1 ? "ies" : "y") + " logged." });
  if (cards.length >= 5) b.push({ key: "builder", icon: "rocket", label: "Hub Builder", desc: cards.length + " cards live." });
  return b;
}

function citationFor({ hubName, ownerName }) {
  const who = ownerName ? ownerName : "the holder";
  return `Awarded to ${who}, who built and now operates ${hubName}, turning scattered AI work into one calm, orchestrated place.`;
}

function GoldSeal({ size = 82 }) {
  const pts = [];
  const n = 24, r1 = 46, r2 = 50, cx = 50, cy = 50;
  for (let i = 0; i < n * 2; i++) {
    const ang = (Math.PI * i) / n;
    const r = i % 2 === 0 ? r2 : r1;
    pts.push(`${(cx + r * Math.cos(ang)).toFixed(1)},${(cy + r * Math.sin(ang)).toFixed(1)}`);
  }
  return (
    <svg width={size} height={size} viewBox="0 0 100 100" aria-hidden="true">
      <defs>
        <linearGradient id="gold" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#f4d680" /><stop offset="0.5" stopColor="#c9962b" /><stop offset="1" stopColor="#9a6f1c" />
        </linearGradient>
      </defs>
      <polygon points={pts.join(" ")} fill="url(#gold)" />
      <circle cx="50" cy="50" r="38" fill="none" stroke="#fbf3da" strokeWidth="2" opacity="0.7" />
      <circle cx="50" cy="50" r="33" fill="#1f2a44" />
      <path d="M40 51 l7 7 14 -15" fill="none" stroke="#f4d680" strokeWidth="4.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export default function Certificate() {
  const [cards, setCards] = useState([]);
  const [counts, setCounts] = useState({ ideas: 0, wins: 0, changelog: 0 });
  const [certs, setCerts] = useState([]);
  const [sel, setSel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [name, setName] = useState(CONFIG.ownerName || "");

  const hubName = CONFIG.ownerName ? `${CONFIG.ownerName}'s AI Hub` : "My AI Hub";

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
    const citation = citationFor({ hubName, ownerName: owner });
    const row = { hub_name: hubName, owner_name: owner, badges, stats: { cards: cards.length, ...counts, citation } };
    try {
      const { data } = await supabase.from("certificates").insert(row).select().single();
      if (data) { setCerts((c) => [data, ...c]); setSel(data); }
    } catch (e) { console.error("cert insert failed", e); }
    setBusy(false);
  }

  if (loading) return <div className="wrap"><div className="empty">Loading…</div></div>;

  const c = sel;
  const badges = c ? (c.badges || []) : [];
  const citation = c && c.stats && c.stats.citation ? c.stats.citation : (c ? citationFor({ hubName: c.hub_name, ownerName: c.owner_name }) : "");
  const serial = c ? String(c.id).replace(/-/g, "").slice(0, 10).toUpperCase() : "";

  return (
    <div className="wrap">
      <div className="hello">Your achievement</div>
      <h1>Certificate</h1>
      <p className="sub">An official, living record of your hub. It grows as your hub fills up. Generate one anytime.</p>

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
          {busy ? "Generating…" : (certs.length ? "Generate a new one" : "Generate your certificate")}
        </button>
      </div>

      {!c ? (
        <div className="empty">No certificate yet. Press the button to mint your first one.</div>
      ) : (
        <div className="cert-frame">
          <div className="cert-corner tl" /><div className="cert-corner tr" /><div className="cert-corner bl" /><div className="cert-corner br" />
          <div className="cert-brand">AI&nbsp;ADVANTAGE</div>
          <div className="cert-kicker">Certificate of Capability</div>
          <div className="cert-seal"><GoldSeal /></div>
          <div className="cert-presents">This certifies</div>
          <div className="cert-name">{c.hub_name}</div>
          {c.owner_name && <div className="cert-owner">operated by {c.owner_name}</div>}

          <div className="cert-purpose">
            <span className="cert-purpose-rule" />
            <span className="cert-purpose-text">Reduce AI Overwhelm</span>
            <span className="cert-purpose-rule" />
          </div>

          <div className="cert-citation">{citation}</div>

          <div className="cert-badges">
            {badges.map((b, i) => (
              <div key={i} className="cert-badge" title={b.desc}>
                <span className="cert-badge-ico"><Icon name={b.icon} size={16} /></span>
                <span className="cert-badge-label">{b.label}</span>
              </div>
            ))}
          </div>

          <div className="cert-sigs">
            {SIGNATORIES.map((n) => (
              <div className="cert-sig" key={n}>
                <div className="cert-sig-name">{n}</div>
                <div className="cert-sig-rule" />
              </div>
            ))}
          </div>
          <div className="cert-issuer">
            AI Advantage Mastery &nbsp;·&nbsp; {new Date(c.created_at).toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" })} &nbsp;·&nbsp; No. {serial}
          </div>
        </div>
      )}

      {certs.length > 1 && (
        <div className="cert-gallery">
          <div className="cert-gallery-head">Your certificates</div>
          <div className="cert-gallery-row">
            {certs.map((x) => (
              <button key={x.id} className={`cert-thumb${sel && sel.id === x.id ? " on" : ""}`} onClick={() => setSel(x)}>
                <Icon name="badge-check" size={15} />
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
