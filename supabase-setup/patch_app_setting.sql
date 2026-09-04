-- 29 ส.ค. 2569: ตารางตั้งค่ากลางของแอป (เช่น ลำดับคอลัมน์) — ใช้ร่วมกันทุกผู้ใช้
create table if not exists app_setting (
  key        text primary key,
  value      jsonb,
  updated_at timestamptz not null default now()
);
alter table app_setting enable row level security;
drop policy if exists app_setting_rw on app_setting;
create policy app_setting_rw on app_setting for all to authenticated using (true) with check (true);
drop trigger if exists trg_updated_at on app_setting;
create trigger trg_updated_at before update on app_setting for each row execute function set_updated_at();
select 'app_setting พร้อมใช้' as result;
