import React, { useEffect, useState, useCallback, useRef } from "react";
import { supabase } from "../integrations/supabase/client";
import { loadVault } from "../lib/vault.js";
import { CONFIG } from "../config.js";
import { Icon } from "../lib/certIcons.jsx";
import aiaIcon from "../assets/aia-icon.png";
import aiaWordmark from "../assets/aia-logo-white.png";

const HUB_TITLE = "My AI Hub Win";
const SIGNATORIES = ["Igor", "Dean", "Tony"];
const SHARE_URL = "https://aiadvantage.com";
const PROMO = "Learn how to amplify yourself and your business with AI Advantage: aiadvantage.com";

const LINES = [
  "I built my own AI Hub, a home for every AI tool, idea, and resource I'm working on.",
  "Everything lives in one place, organized and easy to find.",
];
function captionFor() {
  return `My AI Hub Win 🏆\n\n${LINES[0]} ${LINES[1]}\n\n${PROMO}`;
}

// Capabilities = the hub's built-in apps (always) + tools discovered from the vault (these grow over time).
function detectCapabilities(cards) {
  const has = (re) => cards.some((c) => re.test(c.file || "") || re.test((c.fm && c.fm.title) || ""));
  const caps = [];
  if (has(/brief/i)) caps.push({ icon: "calendar", label: "Daily Briefing" });
  caps.push({ icon: "lightbulb", label: "Ideas Board" });
  caps.push({ icon: "trophy", label: "Wins Tracker" });
  const lib = cards.filter((c) => /^(library|tools|prompts|skills)$/i.test(((c.fm && c.fm.category) || "").trim())).length;
  if (lib > 0) caps.push({ icon: "book", label: "Prompt & Skills Library" });
  if (has(/cheat/i)) caps.push({ icon: "bookmark", label: "Hub Cheat-Sheet" });
  caps.push({ icon: "image", label: "AI Image Studio" });
  caps.push({ icon: "badge-check", label: "Self-Updating Certificate" });
  return caps;
}

export default function Certificate() {
  const [cards, setCards] = useState([]);
  const [certs, setCerts] = useState([]);
  const [sel, setSel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [name, setName] = useState(CONFIG.ownerName || "");
  const [copied, setCopied] = useState(false);
  const [shareMsg, setShareMsg] = useState(null);
  const cardRef = useRef(null);

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
      await loadCerts();
      setLoading(false);
    })();
  }, [loadCerts]);

  async function generate() {
    setBusy(true);
    const owner = (name || "").trim();
    const caps = detectCapabilities(cards);
    const row = { hub_name: "My AI Hub", owner_name: owner, badges: caps, stats: { cards: cards.length } };
    try {
      const { data } = await supabase.from("certificates").insert(row).select().single();
      if (data) { setCerts((c) => [data, ...c]); setSel(data); }
    } catch (e) { console.error("cert insert failed", e); }
    setBusy(false);
  }

  const owner = sel ? (sel.owner_name || "") : "";

  async function makePng() {
    const src = cardRef.current;
    if (!src) return null;
    const mod = await import(/* @vite-ignore */ "https://esm.sh/html-to-image@1.11.11");
    try { if (document.fonts && document.fonts.ready) await document.fonts.ready; } catch (e) { /* ignore */ }
    const w = src.offsetWidth, h = src.offsetHeight;
    const holder = document.createElement("div");
    holder.style.cssText = "position:fixed;left:-10000px;top:0;z-index:-1;pointer-events:none;";
    const clone = src.cloneNode(true);
    clone.style.margin = "0"; clone.style.boxShadow = "none"; clone.style.width = w + "px";
    holder.appendChild(clone);
    document.body.appendChild(holder);
    try {
      await Promise.all(Array.from(clone.querySelectorAll("img")).map((img) =>
        img.complete ? (img.decode ? img.decode().catch(() => {}) : Promise.resolve())
                     : new Promise((res) => { img.onload = img.onerror = res; })));
      const opts = { pixelRatio: 2, backgroundColor: "#0a0e18", width: w, height: h, cacheBust: true };
      await mod.toPng(clone, opts);
      return await mod.toPng(clone, opts);
    } finally { document.body.removeChild(holder); }
  }
  async function download() {
    setShareMsg("Rendering…");
    try {
      const url = await makePng();
      const a = document.createElement("a"); a.href = url; a.download = "my-ai-hub-win.png"; a.click();
      setShareMsg(null);
    } catch { setShareMsg("Could not render the image. Take a screenshot of the card instead."); }
  }
  async function shareCard() {
    setShareMsg("Preparing…");
    try {
      const url = await makePng();
      const blob = await (await fetch(url)).blob();
      const file = new File([blob], "my-ai-hub-win.png", { type: "image/png" });
      if (navigator.canShare && navigator.canShare({ files: [file] })) {
        await navigator.share({ files: [file], text: captionFor() });
        setShareMsg(null);
      } else {
        const a = document.createElement("a"); a.href = url; a.download = "my-ai-hub-win.png"; a.click();
        try { await navigator.clipboard.writeText(captionFor()); } catch (e) { /* ignore */ }
        setShareMsg("Your browser can't attach files to a share, so I downloaded the image and copied the caption — attach the image to your post.");
      }
    } catch (e) {
      if (String(e).includes("Abort")) { setShareMsg(null); return; } // user cancelled the share sheet
      setShareMsg("Couldn't open the share sheet. Use Download image instead.");
    }
  }
  function openIntent(kind) {
    const text = captionFor();
    let u;
    if (kind === "x") u = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}`;
    else if (kind === "li") u = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(SHARE_URL)}`;
    else u = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(SHARE_URL)}`;
    window.open(u, "_blank");
  }
  async function copyCaption() {
    try { await navigator.clipboard.writeText(captionFor()); setCopied(true); setTimeout(() => setCopied(false), 1500); } catch { /* ignore */ }
  }

  if (loading) return <div className="wrap"><div className="empty">Loading…</div></div>;

  const c = sel;
  const caps = c ? (c.badges || []) : [];
  const canShare = typeof navigator !== "undefined" && !!navigator.share;

  return (
    <div className="wrap">
      <div className="hello">Your achievement</div>
      <h1>My AI Hub Win</h1>
      <p className="sub">A shareable snapshot of what your hub is and what it does. Generate one anytime and share it anywhere.</p>

      <div className="cert-actions">
        <input className="cert-name-field" type="text" value={name} onChange={(e) => setName(e.target.value)}
          placeholder="Your name (optional)" maxLength={48}
          onKeyDown={(e) => { if (e.key === "Enter" && !busy) generate(); }} />
        <button className="btn-primary" onClick={generate} disabled={busy}>
          {busy ? "Generating…" : (certs.length ? "Generate a new one" : "Generate your Win card")}
        </button>
      </div>

      {!c ? (
        <div className="empty">No Win card yet. Press the button to mint your first one.</div>
      ) : (
        <>
          <div className="cert-win" ref={cardRef}>
            <div className="cert-win-mark"><img src={aiaIcon} alt="" width="70" height="70" /></div>
            <img className="cert-win-brand" src={aiaWordmark} alt="AI Advantage" />
            <div className="cert-win-title">{HUB_TITLE}</div>

            <div className="cert-win-body">
              {LINES.map((ln, i) => <p key={i}>{ln}</p>)}
            </div>

            <div className="cert-win-cap">
              <span className="cert-win-cap-rule" />
              <span className="cert-win-cap-pill">The capabilities</span>
              <span className="cert-win-cap-rule" />
            </div>

            <div className="cert-win-badges">
              {caps.map((b, i) => (
                <div key={i} className="cert-win-badge">
                  <span className="cert-win-badge-ico"><Icon name={b.icon} size={16} /></span>
                  <span className="cert-win-badge-l">{b.label}</span>
                </div>
              ))}
            </div>
            <div className="cert-win-grow">And they grow as you add tools and wins.</div>

            <div className="cert-win-sigs">
              {SIGNATORIES.map((n) => (
                <div className="cert-win-sig" key={n}>
                  <div className="cert-win-sig-name">{n}</div>
                  <div className="cert-win-sig-rule" />
                </div>
              ))}
            </div>

            <div className="cert-win-foot">
              {(owner ? `Built by ${owner}` : "Built with my AI Hub")} &nbsp;·&nbsp; {new Date(c.created_at).toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" })}
            </div>
            <div className="cert-win-promo">{PROMO}</div>
          </div>

          <div className="cert-share">
            <button className="cert-share-btn primary" onClick={download}>⬇ Download image</button>
            {canShare && <button className="cert-share-btn" onClick={shareCard}>Share…</button>}
            <button className="cert-share-btn" onClick={() => openIntent("x")}>Post on X</button>
            <button className="cert-share-btn" onClick={() => openIntent("li")}>LinkedIn</button>
            <button className="cert-share-btn" onClick={() => openIntent("fb")}>Facebook</button>
            <button className="cert-share-btn" onClick={copyCaption}>{copied ? "Copied!" : "Copy caption"}</button>
          </div>
          <div className="cert-share-hint">Use “Share…” (mobile) or “Download image” to post the card itself. The X, LinkedIn and Facebook buttons prefill your caption and link; attach the downloaded image there.</div>
          {shareMsg && <div className="cert-share-msg">{shareMsg}</div>}
        </>
      )}

      {certs.length > 1 && (
        <div className="cert-gallery">
          <div className="cert-gallery-head">Your Win cards</div>
          <div className="cert-gallery-row">
            {certs.map((x) => (
              <button key={x.id} className={`cert-thumb${sel && sel.id === x.id ? " on" : ""}`} onClick={() => setSel(x)}>
                <Icon name="trophy" size={15} />
                <span>{new Date(x.created_at).toLocaleDateString()}</span>
                <span className="cert-thumb-n">{(x.badges || []).length} capabilities</span>
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
