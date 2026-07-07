-- Prompt Library: user-added prompts (the bundled 337 ship in src/data/promptLibrary.json)
CREATE TABLE public.prompts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL DEFAULT '(untitled)',
  category text DEFAULT 'General',
  kind text NOT NULL DEFAULT 'prompt',
  text text NOT NULL DEFAULT '',
  formula text DEFAULT '',
  favorite boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.prompts TO anon, authenticated;
GRANT ALL ON public.prompts TO service_role;
ALTER TABLE public.prompts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "prompts open all" ON public.prompts FOR ALL USING (true) WITH CHECK (true);
