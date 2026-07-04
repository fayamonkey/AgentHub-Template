Set up my Braindump Palace processor: a background job that turns my raw braindumps into clean, titled cards
while I get on with my day.

Create a scheduled task named `braindump-processor` that runs once a day at 08:00 (I can change the time or
make it more frequent later). Each run, the task does exactly this:

1. Get my repo, token, and database keys. From my CLAUDE.md / setup, find my Hub repo name; use my
   `gh-token.txt` to authenticate git (never print it, always mask github_pat_). Read `src/config.js` from my
   Hub repo and take `supabaseUrl` and `supabaseAnonKey` from it (the Braindump install put them there; the
   anon key is public).

2. Fetch the OLDEST unprocessed braindump — only ONE per run. Call the Supabase REST API:
     GET {supabaseUrl}/rest/v1/braindumps?status=eq.new&order=created_at.asc&limit=1
   with headers:  apikey: {supabaseAnonKey}   and   Authorization: Bearer {supabaseAnonKey}
   If the result is empty, stop, there is nothing to do this run.

3. Process that one braindump. From its `content`, produce:
   - a short, specific `title` (what this thought is really about),
   - a 1-2 sentence `summary` in my own voice,
   - a few `tags` (comma-separated themes, e.g. idea, todo, talk, rant, question, decision),
   - and if it clearly contains action items or concrete ideas, fold a tidy little list of them into the summary.
   Stay faithful to what I dumped; do not invent.

4. Mark it done. PATCH the same row:
     PATCH {supabaseUrl}/rest/v1/braindumps?id=eq.{the id}
   headers: apikey + Authorization: Bearer {supabaseAnonKey}, Content-Type: application/json,
            Prefer: return=minimal
   body: { "title": "...", "summary": "...", "tags": "...", "status": "done", "processed_at": "<now, ISO 8601>" }
   The finished card now shows in my Braindump Palace.

Rules: only read and update the `braindumps` table, nothing else. Never send, post, pay, or delete on my
behalf. Exactly one braindump per run; if there are none, do nothing.

After you create the task, run it once now so I can see it work, then tell me to reload my Hub and open the
Braindump tab.
