-- Run this once in Supabase: SQL Editor > New query > paste > Run

-- 1) Ideas table: one row per idea, owned by the signed-in user
create table if not exists public.ideas (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  duration real not null default 0,
  audio_path text not null,
  mime text
);

alter table public.ideas enable row level security;

drop policy if exists "Users read own ideas" on public.ideas;
drop policy if exists "Users add own ideas" on public.ideas;
drop policy if exists "Users delete own ideas" on public.ideas;

create policy "Users read own ideas" on public.ideas
  for select using (auth.uid() = user_id);

create policy "Users add own ideas" on public.ideas
  for insert with check (auth.uid() = user_id);

create policy "Users delete own ideas" on public.ideas
  for delete using (auth.uid() = user_id);

-- 2) Private bucket for the audio files
insert into storage.buckets (id, name, public)
values ('ideas-audio', 'ideas-audio', false)
on conflict (id) do nothing;

-- 3) Each user can only touch files inside their own folder (folder name = user id)
drop policy if exists "Users read own audio" on storage.objects;
drop policy if exists "Users upload own audio" on storage.objects;
drop policy if exists "Users delete own audio" on storage.objects;

create policy "Users read own audio" on storage.objects
  for select using (
    bucket_id = 'ideas-audio'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users upload own audio" on storage.objects
  for insert with check (
    bucket_id = 'ideas-audio'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users delete own audio" on storage.objects
  for delete using (
    bucket_id = 'ideas-audio'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
