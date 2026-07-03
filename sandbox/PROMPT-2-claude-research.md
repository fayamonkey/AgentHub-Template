# Build your recurring Research (Sandbox)

I'll set up a Research that runs by itself and keeps a fresh card in your Hub's Sandbox, so you can just
look and stay up to date, the digging happens in the background. A few quick questions, then I build it and
run it once so you see your first card.

First, quick context: let me glance at the DNA / context files in this folder so I tune the research to you
and your work. I'll tell you in one line what I picked up. (If there are none, no problem, we go from your
answers.)

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

Then I build it:
- I set it up as a background task on your cadence (daily or weekly). It uses web search by default, and
  browser control only if one of your sources needs a login or a click to reach.
- Each run it does the research your way and writes (overwrites) a Sandbox card at
  content/sandbox-research-<topic>.md (frontmatter: title, emoji 🔎, category: sandbox, updated: today),
  then pushes it to your vault. The card LEADS with what's new or changed since the last run, then the
  detail in the shape you asked for, with sources.
- I run it once now so you get your first card. From then on it keeps itself current, you just open the
  Sandbox to stay up to date.

Then: I tell you how to see it (reload your Hub, open the Sandbox tab). Test it and come back with anything,
we'll refine it. When you only come back happy, I'll ask if it feels final. Once it's final, I'll offer to
zip it up so you can share your Research app with the other students.

Rules: work only inside the Sandbox, cards only, never send/pay/post/delete on your behalf. Read
gh-token.txt only to authenticate git, never print it, always mask github_pat_.
