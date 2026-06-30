-- Images app: AI image generations + customGPT-style presets, stored in Supabase. Open-all (single-user template, same as ideas/wins/certificates).

CREATE TABLE IF NOT EXISTS public.images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  prompt text NOT NULL,
  model text,
  ratio text,
  preset_id uuid,
  storage_path text,
  url text
);
ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "images open all" ON public.images;
CREATE POLICY "images open all" ON public.images FOR ALL USING (true) WITH CHECK (true);

CREATE TABLE IF NOT EXISTS public.image_presets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  name text NOT NULL,
  emoji text,
  instructions text,
  model text,
  ratio text,
  reference_images jsonb NOT NULL DEFAULT '[]'::jsonb
);
ALTER TABLE public.image_presets ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "image_presets open all" ON public.image_presets;
CREATE POLICY "image_presets open all" ON public.image_presets FOR ALL USING (true) WITH CHECK (true);

-- Storage bucket for generated images. PRIVATE (Lovable rejects public buckets);
-- the edge function uploads with the service role and serves images via long-lived signed URLs.
INSERT INTO storage.buckets (id, name, public)
VALUES ('hub-images', 'hub-images', false)
ON CONFLICT (id) DO UPDATE SET public = false;

DROP POLICY IF EXISTS "hub-images read" ON storage.objects;
DROP POLICY IF EXISTS "hub-images insert" ON storage.objects;
DROP POLICY IF EXISTS "hub-images update" ON storage.objects;
DROP POLICY IF EXISTS "hub-images delete" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated read hub-images" ON storage.objects;
CREATE POLICY "Authenticated read hub-images" ON storage.objects FOR SELECT TO authenticated USING (bucket_id = 'hub-images');
DROP POLICY IF EXISTS "Authenticated write hub-images" ON storage.objects;
CREATE POLICY "Authenticated write hub-images" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'hub-images');
DROP POLICY IF EXISTS "Authenticated delete hub-images" ON storage.objects;
CREATE POLICY "Authenticated delete hub-images" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'hub-images');
