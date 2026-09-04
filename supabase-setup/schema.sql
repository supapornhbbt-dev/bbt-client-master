-- BBT Client Master Database — Supabase/PostgreSQL schema
-- โครงตรงกับไฟล์ "BBT - Client Master Database.xlsx" (key = tax_id เลขทะเบียน 13 หลัก)

create table business_nature (
  nature_id        text primary key,
  name_th          text not null,
  business_score   numeric,
  examples         text,
  accounting_notes text
);

create table client (
  tax_id             text primary key check (tax_id ~ '^[0-9]{13}$'),
  client_code        text unique not null,
  name_th            text not null,
  dbd_type           text,
  nature_id          text references business_nature(nature_id),
  client_group       text,
  status             text not null default 'Operate' check (status in ('Operate','Dormant','Closed')),
  record_mode        text check (record_mode in ('คีย์เต็ม','Import ระบบ','ลูกค้าบันทึกเอง')),
  vat_registered     text check (vat_registered in ('Y','N')),
  vat_reg_date_be    text,
  registered_capital numeric,
  income_tax_scheme  text,
  fiscal_year_end    text not null default '31/12',
  fiscal_group       text generated always as (case when fiscal_year_end = '31/12' then 'งบตรงรอบ' else 'งบไม่ตรงรอบ' end) stored,
  software           text,
  software_db        text,
  note               text,
  updated_at         timestamptz not null default now()
);

create table staff (
  staff_token text primary key,
  employee_id text,
  token_en    text,
  name_th     text,
  name_en     text,
  nickname    text,
  level       text,
  start_date  text,
  status      text
);

create table service_job (
  id           bigint generated always as identity primary key,
  tax_id       text not null references client(tax_id) on update cascade,
  service_type text not null,
  service_name text,
  frequency    text,
  fee_month    numeric,
  active       text default 'Y',
  unique (tax_id, service_type)
);

create table task_template (
  template_id  text primary key,
  nature_id    text,
  service_type text,
  period       text,
  task_name    text not null,
  deliverable  text
);

create table coa_mapping (
  map_id        text primary key,
  nature_id     text,
  doc_type      text,
  transaction   text,
  debit         text,
  credit        text,
  vat_treatment text,
  wht           text
);

-- ข้อมูลรายปี: ทีมผู้รับผิดชอบ (เปลี่ยนทุกปี — สร้างปีใหม่ด้วย copy จากปีก่อน)
create table assignment (
  id          bigint generated always as identity primary key,
  work_year   int  not null,
  tax_id      text not null references client(tax_id) on update cascade,
  role        text not null check (role in ('Prepare','Support','Closing','Supervisor','Partner','Payroll')),
  staff_token text not null references staff(staff_token),
  share_pct   numeric not null default 100,
  source_note text,
  updated_at  timestamptz not null default now(),
  unique (work_year, tax_id, role, staff_token)
);

-- ข้อมูลรายปี: ปริมาณงานและชั่วโมง
create table workload_year (
  id               bigint generated always as identity primary key,
  work_year        int  not null,
  tax_id           text not null references client(tax_id) on update cascade,
  v_purchase       numeric, v_sale numeric, v_receive numeric, v_pay numeric,
  v_general        numeric, v_other numeric, v_total numeric,
  account_count    numeric,
  hp text, lease text, loan_bank text, loan_director text, lend_director text, fixed_assets text,
  score_volume     numeric, score_business numeric, score_complex numeric, score_total numeric,
  difficulty       text,
  hours_month      numeric,
  hours_close_year numeric,
  hours_year       numeric,
  hours_month_prev numeric,
  calc_reason      text,
  hours_class      text,
  updated_at       timestamptz not null default now(),
  unique (work_year, tax_id)
);

create table financial_period (
  id               bigint generated always as identity primary key,
  tax_id           text not null references client(tax_id) on update cascade,
  fiscal_year_be   int not null,
  period           text not null default 'FULL',
  revenue          numeric,
  expenses         numeric,
  net_profit       numeric generated always as (coalesce(revenue,0) - coalesce(expenses,0)) stored,
  tax_paid         numeric,
  pnd51_est_profit numeric,
  source           text,
  note             text,
  unique (tax_id, fiscal_year_be, period)
);

-- ผู้ใช้ 4 คน: partner 3 + admin 1 (เชื่อมกับ Supabase Auth)
create table app_user (
  user_id    uuid primary key references auth.users(id),
  full_name  text,
  app_role   text not null default 'partner' check (app_role in ('partner','admin'))
);

-- ฟังก์ชันสร้างปีใหม่จากปีก่อน (assignment + workload)
create or replace function copy_year(from_year int, to_year int) returns void language sql as $$
  insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
  select to_year, tax_id, role, staff_token, share_pct, 'คัดลอกจากปี ' || from_year
  from assignment where work_year = from_year
  on conflict do nothing;
  insert into workload_year (work_year, tax_id, v_purchase, v_sale, v_receive, v_pay, v_general, v_other,
    v_total, account_count, hp, lease, loan_bank, loan_director, lend_director, fixed_assets,
    score_volume, score_business, score_complex, score_total, difficulty,
    hours_month, hours_close_year, hours_year, hours_month_prev, calc_reason, hours_class)
  select to_year, tax_id, v_purchase, v_sale, v_receive, v_pay, v_general, v_other,
    v_total, account_count, hp, lease, loan_bank, loan_director, lend_director, fixed_assets,
    score_volume, score_business, score_complex, score_total, difficulty,
    hours_month, hours_close_year, hours_year, hours_month, 'คัดลอกจากปี ' || from_year, hours_class
  from workload_year where work_year = from_year
  on conflict do nothing;
$$;

-- Row Level Security: ล็อกอินแล้วเท่านั้นจึงอ่าน/แก้ได้ (ทั้ง 4 คนแก้ได้หมด — ปรับละเอียดทีหลังได้)
alter table business_nature  enable row level security;
alter table client           enable row level security;
alter table staff            enable row level security;
alter table service_job      enable row level security;
alter table task_template    enable row level security;
alter table coa_mapping      enable row level security;
alter table assignment       enable row level security;
alter table workload_year    enable row level security;
alter table financial_period enable row level security;
alter table app_user         enable row level security;

do $$ declare t text;
begin
  foreach t in array array['business_nature','client','staff','service_job','task_template','coa_mapping','assignment','workload_year','financial_period']
  loop
    execute format('create policy %I_rw on %I for all to authenticated using (true) with check (true)', t, t);
  end loop;
end $$;
create policy app_user_read on app_user for select to authenticated using (true);
