# Vox

Voice notes for ideas. Sign in with an email and password, record an idea, and find it on any device.

Vox is a single static page (`index.html`) backed by [Supabase](https://supabase.com) for accounts, the ideas list, and private audio storage.

## Setup

1. **Create a Supabase project** at supabase.com (free tier is enough).
2. **Create the tables and storage.** In the SQL Editor, paste the contents of `supabase-setup.sql` and run it once.
3. **Add your keys.** In `index.html`, set `SUPABASE_URL` and `SUPABASE_ANON_KEY` at the top of the script. Use the Project URL and the publishable key from Project Settings > API Keys. Never put a secret key in this file.
4. **Set the URLs.** In Supabase, go to Authentication > URL Configuration and set the Site URL and Redirect URLs to where this page is hosted, for example `https://<user>.github.io/vox/` and `https://<user>.github.io/vox/**`.

## Hosting

This is a static site. Deploy it with GitHub Pages (Settings > Pages > Deploy from a branch > `main` / root), or any host that serves HTML files.

## Notes

- Each account only sees its own ideas. Audio files are stored in a private bucket and accessed through short-lived signed links.
- Recordings are saved as WebM (Chrome, Edge, Firefox) or MP4 (Safari).
