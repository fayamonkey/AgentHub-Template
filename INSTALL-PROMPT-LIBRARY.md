# Add the Prompt Library to your hub

This branch (`feature/prompt-library`) adds a searchable **Prompt Library** app:
337 ready-to-use prompts, styles & follow-ups, seeded into your hub's Supabase,
plus a "＋ Add prompt" that saves your own (they travel with your hub).

## Install (one short step in Lovable)

Paste this into your hub's Lovable chat:

> Merge the branch `feature/prompt-library` into main and run the new database
> migrations. Don't change anything else.

Lovable pulls in the files and runs the two migrations
(`…_prompts_table.sql`, `…_prompts_seed.sql`), which create the `prompts` table
and load all 337 rows into your Supabase.

## Or via GitHub (always works)

Open a Pull Request from `feature/prompt-library` → `main`, merge it, then let
Lovable sync. On the next deploy the migrations run and the library is live.

## What you get
- New **Prompt Library** tab (top nav + homepage tile)
- Search by keyword/tag; filter by type (Prompts / Follow-ups / Styles),
  category, and favorites — navigation sits on top, works on mobile
- One-click copy; add / delete your own prompts (stored in Supabase)

No secrets, no other files touched.
