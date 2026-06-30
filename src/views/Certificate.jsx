import React, { useEffect, useState, useCallback } from "react";
import { supabase } from "../integrations/supabase/client";
import { loadVault } from "../lib/vault.js";
import { CONFIG } from "../config.js";
import { Icon } from "../lib/certIcons.jsx";

function detectBadges({ cards, ideas, wins, changelog }) {
  const b = [];
  b.push({ key: "hub", icon: "badge-check", label: "AgentHub Operator", desc: "Built and runs a private AI hub." });
  if (cards.length > 0) b.push({ key: "chain", icon: "link", label: "Three-Tool Chain", desc: "Lovable, GitHub and Cowork wired into one loop." });
  if (cards.some((c) => (c.fm && c.fm.schedule) || /briefing/i.test(c.file || ""))) b.push({ key: "auto", icon: "repeat", label: "Self-Feeding Automation", desc: "A scheduled task that fills the hub on its own." });
  if (cards.some((c) => /cheat/i.test(c.file || "") || /cheat/i.test((c.fm && c.fm.title) || ""))) b.push({ key: "cheat", icon: "bookmark", label: "Hub Cheat-Sheet", desc: "Keeps a working reference on hand." });
  const lib = cards.filter((c) => ((c.fm && c.fm.category) || "").toLowerCase() === "library").length;
  if (lib > 0) b.push({ key: "library", icon: "book", label: "Library Curator", desc: lib + " reference card" + (lib > 1 ? "s" : "") + " saved." });
  if (ideas > 0) b.push({ key: "ideas", icon: "lightbulb", label: "Ideas in Motion", desc: ideas + " idea" + (ideas > 1 ? "s" : "") + " on the board." });
  if (wins > 0) b.push({ key: "wins", icon: "trophy", label: "Wins Shipped", desc: wins + " win" + (wins > 1 ? "s" : "") + " on the wall." });
  if (changelog > 0) b.push({ key: "log", icon: "history", label: "Changelog Keeper", desc: changelog + " entr" + (changelog > 1 ? "ies" : "y") + " logged." });
  if (cards.length >= 5) b.push({ key: "builder", icon: "rocket", label: "Hub Builder", desc: cards.length + " cards live in the hub." });
  return b;
}

export default function Certificate() {
  const [cards, setCards] = useState([]);
  const [counts, setCounts] = useState({ ideas: 0, wins: 0, changelog: 0 });
  const [certs, setCerts] = useState([]);
  const [sel, setSel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);

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
    const badges = detectBadges({ cards, ideas: counts.ideas, wins: counts.wins, changelog: counts.changelog });
    const row = { hub_name: hubName, owner_name: CONFIG.ownerName || "", badges, stats: { cards: cards.length, ...counts } };
    try {
      const { data } = await supabase.from("certificates").insert(row).select().single();
      if (data) { setCerts((c) => [data, ...c]); setSel(data); }
    } catch (e) { console.error("cert insert failed", e); }
    setBusy(false);
  }

  if (loading) return <div className="wrap"><div className="empty">Loading…</div></div>;

  const c = sel;
  const badges = c ? (c.badges || []) : [];

  return (
    <div className="wrap">
      <div className="hello">Your achievement</div>
      <h1>Certificate</h1>
      <p className="sub">A living snapshot of what your hub is and what you can do. Generate one anytime; each is saved.</p>

      <div className="cert-actions">
        <button className="btn-primary" onClick={generate} disabled={busy}>
          {busy ? "Generating…" : (certs.length ? "Generate a new one" : "Generate your certificate")}
        </button>
      </div>

      {!c ? (
        <div className="empty">No certificate yet. Press the button to mint your first one.</div>
      ) : (
        <div className="cert">
          <div className="cert-head">
            <div className="cert-seal"><Icon name="badge-check" size={40} /></div>
            <div className="cert-issued">Certificate of Capability</div>
          </div>
          <div className="cert-name">{c.hub_name}</div>
          {c.owner_name && <div className="cert-owner">operated by {c.owner_name}</div>}
          <div className="cert-date">{new Date(c.created_at).toLocaleDateString(undefined, { year: "numeric", month: "long", day: "numeric" })}</div>
          <div className="cert-badges">
            {badges.map((b, i) => (
              <div key={i} className="cert-badge">
                <div className="cert-badge-ico"><Icon name={b.icon} size={26} /></div>
                <div className="cert-badge-text">
                  <div className="cert-badge-label">{b.label}</div>
                  <div className="cert-badge-desc">{b.desc}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {certs.length > 1 && (
        <div className="cert-gallery">
          <div className="cert-gallery-head">Your certificates</div>
          <div className="cert-gallery-row">
            {certs.map((x) => (
              <button key={x.id} className={`cert-thumb${sel && sel.id === x.id ? " on" : ""}`} onClick={() => setSel(x)}>
                <Icon name="badge-check" size={16} />
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
