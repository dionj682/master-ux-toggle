-- Master UX Toggle — free-tier Postgres
create table if not exists public.todo_items (
  id text primary key,
  text text not null,
  person text,
  account text,
  urgency int,
  done boolean not null default false,
  note text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.todo_items enable row level security;

-- Personal board: anon key may read/write (no public user accounts).
-- RLS is on; policies intentionally allow the published anon role only.
drop policy if exists "anon read todo_items" on public.todo_items;
drop policy if exists "anon insert todo_items" on public.todo_items;
drop policy if exists "anon update todo_items" on public.todo_items;
drop policy if exists "anon delete todo_items" on public.todo_items;

create policy "anon read todo_items" on public.todo_items
  for select to anon using (true);
create policy "anon insert todo_items" on public.todo_items
  for insert to anon with check (true);
create policy "anon update todo_items" on public.todo_items
  for update to anon using (true) with check (true);
create policy "anon delete todo_items" on public.todo_items
  for delete to anon using (true);

grant select, insert, update, delete on public.todo_items to anon;
grant select, insert, update, delete on public.todo_items to authenticated;
