-- Certificates: saved, versioned diplomas of what the hub operator can do. Open-all (single-user template, same as ideas/wins).
CREATE TABLE IF NOT EXISTS public.certificates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  hub_name text,
  owner_name text,
  badges jsonb NOT NULL DEFAULT '[]'::jsonb,
  stats jsonb NOT NULL DEFAULT '{}'::jsonb
);
ALTER TABLE public.certificates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "certificates open all" ON public.certificates FOR ALL USING (true) WITH CHECK (true);
