-- 뽀모도로 기록 테이블
-- Supabase 대시보드 → SQL Editor 에 그대로 붙여넣고 Run

create table if not exists public.pomo_log (
  user_id    uuid        not null references auth.users(id) on delete cascade,
  day        date        not null,
  sessions   integer     not null default 0,
  seconds    integer     not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, day)
);

-- 행 단위 보안: 로그인한 본인의 행만 읽고 쓸 수 있다
alter table public.pomo_log enable row level security;

drop policy if exists "own rows only" on public.pomo_log;
create policy "own rows only" on public.pomo_log
  for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
