-- BRAINDUMPS (Braindump Palace)
CREATE TABLE public.braindumps (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content text NOT NULL,
  source text DEFAULT 'typed',
  status text NOT NULL DEFAULT 'new',   -- new | done
  title text DEFAULT '',
  summary text DEFAULT '',
  tags text DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  processed_at timestamptz
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.braindumps TO anon, authenticated;
GRANT ALL ON public.braindumps TO service_role;
ALTER TABLE public.braindumps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "braindumps open all" ON public.braindumps FOR ALL USING (true) WITH CHECK (true);
