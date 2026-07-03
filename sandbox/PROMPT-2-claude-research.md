<!-- TESTING: pulls from the AgentHub-Template `sandbox` (dev) branch. When live, swap `sandbox` -> `main` in the URL above. -->

# Build your recurring Research (Sandbox) — one prompt, start to finish

I'll set up a Research that runs by itself and keeps a fresh card in your Hub's Sandbox, so you can just
look and stay up to date, the digging happens in the background. This single prompt does everything, there
is no separate Lovable step. A few quick questions, then I build it and run it once so you see your first
card.

First, quick context: let me glance at the DNA / context files in this folder so I tune the research to you
and your work. I'll tell you in one line what I picked up. Then I'll ask if you have more DNA or context to
share before we go on. (If there are none, no problem, we go from your answers.)

Then read the platform's own context so you build something that fits the Hub: fetch and read
https://raw.githubusercontent.com/fayamonkey/AgentHub-Template/sandbox/AGENTHUB-DNA.md
It is the AgentHub DNA, the card convention, the Sandbox, and the background-work principle. Follow it.

Then three questions, one at a time:

1. WHAT do you want to keep an eye on? The thing you research regularly, the topic you want to stay on top
   of. Examples: competitor prices, what customers are saying about X, news and moves in your field, a
   market, or a specific set of companies. And how often should it refresh, daily or weekly?

2. HOW do you usually do this research? Where you look, which sources or sites you trust, what you search
   for, and what makes a result actually useful versus noise to you. I'll do it your way, using your
   experience, not a generic sweep.

3. WHAT do you need out of it? What should the card give you, and what do you use it for? For example: a
   short summary, a list of what's new since last time, specific numbers or prices, links to the sources, a
   heads-up flag when something important shifts. Tell me the shape and the length that's genuinely useful.

Then I build it, all in one go:

- **Make sure your Hub has a Sandbox tab.** I'll look at your Hub's repo (the one named in your CLAUDE.md /
  config). If it does not already have a "sandbox" category, I'll add exactly this one line as the first
  item of the CATEGORIES list in src/App.jsx, and push it:

  { id: "sandbox", label: "Sandbox", emoji: "🧪", blurb: "Mini-apps you build here, safe from the rest of your Hub" },

  then tell you to hit **Sync** in Lovable once so the Sandbox tab appears. I only touch that one line and
  nothing else in that file. If your Hub isn't the standard template and I'm not certain where the line
  goes, I'll stop and hand you a one-line Lovable prompt instead, rather than guess and risk your Hub.

- **Set up the research as a background task** on your cadence (daily or weekly). It uses web search by
  default, and browser control only if one of your sources needs a login or a click to reach.

- Each run it does the research your way and writes (overwrites) a Sandbox card at
  content/sandbox-research-<topic>.md (frontmatter: title, emoji 🔎, category: sandbox, updated: today),
  then pushes it to your vault. The card LEADS with what's new or changed since the last run, then the
  detail in the shape you asked for, with sources.

- I run it once now so you get your first card.

Then: reload your Hub and open the Sandbox tab to see it. Test it and come back with anything, we'll refine
it. When you only come back happy, I'll ask if it feels final. Once it's final, I'll offer to zip it up so
you can share your Research app with the other students.

Rules: work only inside the Sandbox, cards only, never send/pay/post/delete on your behalf. Read
gh-token.txt only to authenticate git, never print it, always mask github_pat_.
