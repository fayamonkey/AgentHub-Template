-- Seed three example image presets so every new hub ships with ready-to-use examples.
-- Runs once at build. Fixed ids + ON CONFLICT keep it idempotent. Presets stay fully deletable:
-- migrations do not re-run, so a deleted example does not come back.
INSERT INTO public.image_presets (id, created_at, name, emoji, instructions, model, ratio, reference_images)
VALUES
(
  'a0e17e00-0000-4000-8000-000000000001', now(), 'My Brand', '🏷️',
  $preset$Always create images in MY brand style, so everything looks consistent.

- Colors: use [MAIN COLOR] and [ACCENT COLOR]. Backgrounds mostly [light / dark].
- Feeling: [e.g. calm, clean and premium].
- Look: [e.g. real photography / flat illustration / 3D render]. Keep it simple, lots of clean space, never cluttered.
- My logo (attached): place it [e.g. bottom-right], small and tidy, never stretched or recolored.
- Never use: [e.g. stock-photo people, busy patterns, neon colors].
- Text in the image: [only if I ask / never].

Whatever I describe, apply these rules so every image clearly belongs to my brand.$preset$,
  'google/gemini-2.5-flash-image', '1:1', '[]'::jsonb
),
(
  'a0e17e00-0000-4000-8000-000000000002', now() - interval '1 second', 'Doodle', '✏️',
  $preset$Turn whatever I describe into a simple hand-drawn doodle.

- Style: black felt-tip pen on plain white paper, loose and playful, thick slightly wobbly lines, like a quick notebook sketch.
- Keep it minimal: just the main thing plus a couple of fun details. No background, black ink only (unless I ask for one splash of color).
- No realism, no photos, no soft shading. It should look charming and hand-drawn.
- Center the subject with clean white space around it.

Whatever I type, draw it as this kind of doodle.$preset$,
  NULL, '1:1', '[]'::jsonb
),
(
  'a0e17e00-0000-4000-8000-000000000003', now() - interval '2 seconds', 'Clean Illustration', '🖌️',
  $preset$Turn whatever I describe into a clean, modern flat illustration I can drop into a blog post, slide, newsletter, or social post.

- Style: simple modern flat vector illustration, friendly and professional, smooth shapes, soft shadows, a small tasteful palette of 2 to 4 colors, lots of clean negative space.
- Keep it clear and uncluttered: one main idea, easy to read at a glance.
- No text or words in the image. No photorealism, no 3D, no busy background.
- A consistent, polished look every time, like the illustrations on a good SaaS landing page.

Whatever I type, illustrate it in this clean style.$preset$,
  'google/gemini-2.5-flash-image', '16:9', '[]'::jsonb
)
ON CONFLICT (id) DO NOTHING;
