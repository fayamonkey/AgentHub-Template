Set up my Braindump Palace processor: a daily background job that turns my raw braindumps into clean, titled
cards, entirely over git, no external services.

Create a scheduled task named `braindump-processor` that runs once a day at 08:00 (I can change the time or
make it more frequent later). Each run, it does exactly this:

1. Clone my Hub repo. Find my Hub repo name from my CLAUDE.md / setup, and clone it with plain git over
   HTTPS, using my gh-token.txt to authenticate (never print it, always mask github_pat_).

2. Find the oldest unprocessed braindump — only ONE per run. In the repo's content/ folder, look at every
   file named braindump-*.md. Each has frontmatter with a `status` field. Take the one with
   status: pending and the earliest filename (the timestamp in the name). If there are none, stop, there is
   nothing to do this run.

3. Process that one braindump. Its body is my raw dump. Produce:
   - a short, specific title (what this thought is really about),
   - a 1-2 sentence summary in my own voice,
   - a few tags (comma-separated, e.g. idea, todo, talk, rant, question, decision),
   - and if it clearly contains action items or concrete ideas, a tidy little list of them.
   Stay faithful to what I dumped; do not invent.

4. Rewrite that same file as a finished card and push it. Keep the same filename. Set the frontmatter to:
     title: <the real title>   (drop the 🌀)
     emoji: 🧠
     category: braindump
     status: done
     tags: <the tags>
     updated: <today, YYYY-MM-DD>
   and write the body as: the summary first, then the action-item list (if any), then a final section
   titled "**Original**" with my raw dump underneath it. Commit and push (git pull --rebase first if the
   push is rejected).
   The finished card now shows in my Braindump tab.

Rules: only touch files matching content/braindump-*.md, nothing else. Never send, post, pay, or delete on
my behalf. Exactly one braindump per run; if none are pending, do nothing.

After you create the task, run it once now so I can see it work, then tell me to reload my Hub and open the
Braindump tab.
