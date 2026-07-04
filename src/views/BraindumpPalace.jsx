import React, { useEffect, useRef, useState } from "react";
import { supabase } from "../integrations/supabase/client";

export default function BraindumpPalace() {
  const [dumps, setDumps] = useState([]);
  const [loading, setLoading] = useState(true);
  const [text, setText] = useState("");
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);
  const [listening, setListening] = useState(false);
  const [open, setOpen] = useState(null);
  const recogRef = useRef(null);

  async function load() {
    setLoading(true);
    const { data } = await supabase
      .from("braindumps")
      .select("*")
      .order("created_at", { ascending: false });
    setDumps(data || []);
    setLoading(false);
  }
  useEffect(() => { load(); }, []);

  async function send() {
    const content = text.trim();
    if (!content) return;
    setSending(true);
    await supabase.from("braindumps").insert({
      content,
      source: listening ? "voice" : "typed",
      status: "new",
    });
    setText("");
    setSending(false);
    setSent(true);
    setTimeout(() => setSent(false), 2500);
    load();
  }

  // Voice -> text via the browser's Speech API. Absent gracefully on unsupported browsers.
  const SR = typeof window !== "undefined" && (window.SpeechRecognition || window.webkitSpeechRecognition);
  function toggleMic() {
    if (!SR) return;
    if (listening) { recogRef.current && recogRef.current.stop(); setListening(false); return; }
    const r = new SR();
    r.lang = (typeof navigator !== "undefined" && navigator.language) || "en-US";
    r.continuous = true;
    r.interimResults = true;
    const base = text ? text + " " : "";
    r.onresult = (e) => {
      let interim = "";
      for (let i = e.resultIndex; i < e.results.length; i += 1) interim += e.results[i][0].transcript;
      setText(base + interim);
    };
    r.onend = () => setListening(false);
    r.onerror = () => setListening(false);
    recogRef.current = r;
    r.start();
    setListening(true);
  }

  return (
    <div className="wrap">
      <div className="hello">Capture</div>
      <h1>🧠 Braindump</h1>
      <p className="sub">Dump any thought here. Claude sorts each one into a clean, titled card while you get on with your day.</p>

      <div className="bd-input">
        <textarea
          rows={4}
          placeholder="What's on your mind? Type it, or tap the mic and just talk…"
          value={text}
          onChange={(e) => setText(e.target.value)}
        />
        <div className="bd-inputrow">
          {SR && (
            <button type="button" className={`btn-ghost${listening ? " bd-mic-on" : ""}`} onClick={toggleMic}>
              {listening ? "● Listening… tap to stop" : "🎤 Speak"}
            </button>
          )}
          <div className="bd-spacer" />
          {sent && <span className="bd-sent">✓ Caught. Claude will process it.</span>}
          <button className="btn-primary" onClick={send} disabled={sending || !text.trim()}>
            {sending ? "Sending…" : "Send to the Palace"}
          </button>
        </div>
      </div>

      {loading ? (
        <div className="empty">Loading…</div>
      ) : dumps.length === 0 ? (
        <div className="empty">Your Palace is empty. Drop your first thought above.</div>
      ) : (
        <div className="bd-list">
          {dumps.map((d) => (
            <div
              key={d.id}
              className={`bd-card${d.status === "new" ? " bd-pending" : ""}`}
              onClick={() => d.status === "done" && setOpen(d)}
            >
              {d.status === "new" ? (
                <>
                  <div className="bd-title">🌀 In the queue</div>
                  <div className="bd-preview">{d.content.slice(0, 160)}{d.content.length > 160 ? "…" : ""}</div>
                  <div className="bd-meta">Claude turns this into a card on its next run.</div>
                </>
              ) : (
                <>
                  <div className="bd-title">{d.title || "Braindump"}</div>
                  {d.summary && <div className="bd-preview">{d.summary}</div>}
                  {d.tags && (
                    <div className="bd-tags">
                      {d.tags.split(",").filter(Boolean).map((t, i) => <span key={i} className="bd-tag">{t.trim()}</span>)}
                    </div>
                  )}
                </>
              )}
            </div>
          ))}
        </div>
      )}

      {open && (
        <div className="modal" onClick={(e) => e.target.className === "modal" && setOpen(null)}>
          <div className="panel">
            <button className="x" onClick={() => setOpen(null)}>×</button>
            <h2 style={{ marginTop: 0 }}>{open.title || "Braindump"}</h2>
            {open.summary && <p className="sub" style={{ marginTop: 0 }}>{open.summary}</p>}
            {open.tags && (
              <div className="bd-tags">
                {open.tags.split(",").filter(Boolean).map((t, i) => <span key={i} className="bd-tag">{t.trim()}</span>)}
              </div>
            )}
            <h3>Your original</h3>
            <div className="bd-original">{open.content}</div>
          </div>
        </div>
      )}
    </div>
  );
}
