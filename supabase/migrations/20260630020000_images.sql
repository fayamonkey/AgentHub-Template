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

-- Public storage bucket for generated images (easy display + download)
INSERT INTO storage.buckets (id, name, public)
VALUES ('hub-images', 'hub-images', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "hub-images read" ON storage.objects;
CREATE POLICY "hub-images read" ON storage.objects FOR SELECT USING (bucket_id = 'hub-images');
DROP POLICY IF EXISTS "hub-images insert" ON storage.objects;
CREATE POLICY "hub-images insert" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'hub-images');
DROP POLICY IF EXISTS "hub-images update" ON storage.objects;
CREATE POLICY "hub-images update" ON storage.objects FOR UPDATE USING (bucket_id = 'hub-images');
DROP POLICY IF EXISTS "hub-images delete" ON storage.objects;
CREATE POLICY "hub-images delete" ON storage.objects FOR DELETE USING (bucket_id = 'hub-images');
