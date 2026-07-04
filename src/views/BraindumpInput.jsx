import React, { useRef, useState } from "react";
import { CONFIG } from "../config.js";
import { supabase } from "../integrations/supabase/client";

export default function BraindumpInput() {
  const [text, setText] = useState("");
  const [sending, setSending] = useState(false);
  const [msg, setMsg] = useState("");
  const [listening, setListening] = useState(false);
  const recogRef = useRef(null);

  async function send() {
    const content = text.trim();
    if (!content) return;
    setSending(true); setMsg("");
    try {
      const { data, error } = await supabase.functions.invoke("submit-braindump", {
        body: { repo: CONFIG.githubRepo, folder: CONFIG.vaultFolder || "content", content, source: listening ? "voice" : "typed" },
      });
      if (error || (data && data.error)) throw new Error((data && data.error) || (error && error.message));
      setText(""); setMsg("saved");
    } catch (e) {
      setMsg("error");
    }
    setSending(false);
  }

  const SR = typeof window !== "undefined" && (window.SpeechRecognition || window.webkitSpeechRecognition);
  function toggleMic() {
    if (!SR) return;
    if (listening) { recogRef.current && recogRef.current.stop(); setListening(false); return; }
    const r = new SR();
    r.lang = (typeof navigator !== "undefined" && navigator.language) || "en-US";
    r.continuous = true; r.interimResults = true;
    const base = text ? text + " " : "";
    r.onresult = (e) => { let s = ""; for (let i = e.resultIndex; i < e.results.length; i += 1) s += e.results[i][0].transcript; setText(base + s); };
    r.onend = () => setListening(false);
    r.onerror = () => setListening(false);
    recogRef.current = r; r.start(); setListening(true);
  }

  return (
    <div className="bd-input">
      <textarea rows={4} placeholder="What's on your mind? Type it, or tap the mic and just talk…"
        value={text} onChange={(e) => setText(e.target.value)} />
      <div className="bd-inputrow">
        {SR && (
          <button type="button" className={`btn-ghost${listening ? " bd-mic-on" : ""}`} onClick={toggleMic}>
            {listening ? "● Listening… tap to stop" : "🎤 Speak"}
          </button>
        )}
        <div className="bd-spacer" />
        {msg === "saved" && <span className="bd-sent">✓ Caught. <a href="#" onClick={(e) => { e.preventDefault(); window.location.reload(); }}>Reload</a> to see it in the queue.</span>}
        {msg === "error" && <span className="bd-err">Didn't save, try again in a moment.</span>}
        <button className="btn-primary" onClick={send} disabled={sending || !text.trim()}>
          {sending ? "Sending…" : "Send to the Palace"}
        </button>
      </div>
    </div>
  );
}
