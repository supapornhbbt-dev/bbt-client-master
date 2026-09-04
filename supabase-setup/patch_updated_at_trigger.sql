-- แพตช์ 29 ส.ค. 2569: ให้คอลัมน์ updated_at อัปเดตเองทุกครั้งที่มีการแก้ไขแถว
-- (เดิม default now() ทำงานเฉพาะตอน insert — แก้ข้อมูลแล้วเวลาไม่ขยับ ทำให้ตรวจย้อนหลังไม่ได้)
-- และล้างค่า hours_class เก่าที่ค้างจาก import ก.ค. (เว็บคำนวณสดเองแล้ว ไม่มีอะไรอ่านค่านี้อีก)

create or replace function set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

-- เพิ่มคอลัมน์ updated_at ให้ตารางหลักที่มีการแก้จากเว็บ (ตารางไหนมีแล้วข้ามให้เอง)
alter table client        add column if not exists updated_at timestamptz not null default now();
alter table staff         add column if not exists updated_at timestamptz not null default now();
alter table assignment    add column if not exists updated_at timestamptz not null default now();
alter table workload_year add column if not exists updated_at timestamptz not null default now();
alter table service_job   add column if not exists updated_at timestamptz not null default now();

drop trigger if exists trg_updated_at on client;
create trigger trg_updated_at before update on client        for each row execute function set_updated_at();
drop trigger if exists trg_updated_at on staff;
create trigger trg_updated_at before update on staff         for each row execute function set_updated_at();
drop trigger if exists trg_updated_at on assignment;
create trigger trg_updated_at before update on assignment    for each row execute function set_updated_at();
drop trigger if exists trg_updated_at on workload_year;
create trigger trg_updated_at before update on workload_year for each row execute function set_updated_at();
drop trigger if exists trg_updated_at on service_job;
create trigger trg_updated_at before update on service_job   for each row execute function set_updated_at();

-- ล้างค่ากลุ่มชั่วโมงเก่า (เว็บและไฟล์ส่งออกคำนวณสดจาก calcHoursClass แล้ว)
update workload_year set hours_class = null where hours_class is not null;
