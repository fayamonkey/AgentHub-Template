# AgentHub DNA

_This file is the platform's own context. When a member runs the Sandbox builder prompt, Claude reads
this so it proposes and builds mini-apps that actually fit the Hub. Do not put personal data here; the
member's personal DNA lives in their own connected folder._

---

## What the AgentHub is

A member's private AI Hub: a small Vite + React website (built in Lovable, backed by Lovable Cloud /
Supabase) that shows **cards** pulled at runtime from the member's private GitHub "vault" repo. The Hub
is the member's single place where everything their AI does for them shows up.

Built-in apps: **Ideas** (kanban), **Wins** (tracker), **Images** (AI image studio), **Certificate**
(shareable win card). Categories of cards: **Sandbox**, **Tools**, **Library**.

## The Sandbox

`Sandbox` is a walled-off category in the Hub for member-built **mini-apps**. Anything built here surfaces
as a card and can never break the core apps. This is the only place the builder prompt should add things.

A "mini-app" is small and personal: it does one useful job for this one member, on a schedule or on
demand, and shows its latest result as a card in the Sandbox.

## The card convention (how anything appears in the Hub)

- A card is a markdown file in the member's **vault repo**, under the folder named in config.js
  (vaultFolder, default "content").
- Top-level content/<name>.md files show on the Hub. Frontmatter required:
  title, emoji, category, updated (today's date).
- **Sandbox mini-apps must use category: sandbox** so they land in the Sandbox and nowhere else.
- Always-current app: one fixed filename, overwritten each run (e.g. content/sandbox-<app>.md).
- Dated / rolling app: a dated filename (e.g. content/sandbox-<app>-<YYYY-MM-DD>.md); the Hub shows the newest.
- Writing = commit the file to the vault repo with plain git over HTTPS and push. The member's
  gh-token.txt (in their connected folder) authenticates. Never print or commit that token.

## The two ways a mini-app can run

**1. Claude-in-the-background (recommended, the strongest path).**
Claude (in the member's Cowork agenthub folder) does the actual work and writes/updates a Sandbox card,
then pushes it to the vault. Runs on demand or as a scheduled task. **Zero Hub code changes, so it can
never break anything.** Best for: anything that needs real reasoning, real data from the member's
connectors, web research, drafting, summarizing, watching something and reporting. This is where the
"wow" is, the member's own AI employee doing a real recurring job and surfacing it as a card.
- Delivery: a small task prompt (and, if recurring, a scheduled task) plus a Card-Emitter step that
  writes content/sandbox-<app>.md (category: sandbox) and pushes.

**2. Lovable-LLM (in-browser).**
A small interactive view Lovable builds inside the Sandbox that calls the built-in Lovable AI gateway.
Runs on the member's **Lovable AI credits**. Best for: a quick in-Hub interaction (type something, get an
LLM answer or a generated snippet) where the member wants to click, not wait for a background run.
- Delivery: a Lovable handoff describing one contained Sandbox view. Keep it self-contained; never touch
  the built-in apps.

Prefer path 1 unless the app is genuinely an in-browser click-and-answer tool.

## What's available to a Claude-background mini-app

- **The member's connectors** (whatever they have connected in Cowork): typically Gmail/Calendar/Todoist,
  sometimes meeting transcripts (Fireflies/Zoom), Drive, Slack, and others. Use only what's connected;
  skip gracefully if one is missing.
- **Claude's own abilities**: web search + fetch, reading/writing files in the connected folder, running
  code in the sandbox, and scheduled tasks.
- **The vault**: read existing cards for context, write new Sandbox cards.

## Hard safety rules for anything built in the Sandbox

- Cards only. A Sandbox app writes cards to the vault; it does not modify the Hub's app code or other categories.
- Never send, pay, post, share publicly, or delete on the member's behalf. Drafts and cards only, unless
  the member explicitly does the action themselves.
- Never expose secrets. The gh-token.txt and any API keys stay local and masked.
- One member, their data. A mini-app serves this member from their own context; it does not compile or
  send their data anywhere.

## How to pick 3 good mini-apps for a member

Ground every idea in the member's **personal DNA** (their role, goals, tools, recurring pains, the kind of
work they do). A good mini-app is: small, obviously useful to them this week, runnable now with what's
connected, and a clear fit for path 1 or path 2. Favor recurring jobs that quietly save them time and show
up as a fresh card, over one-off toys.
