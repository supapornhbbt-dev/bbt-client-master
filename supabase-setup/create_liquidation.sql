-- 30 ส.ค. 2569: ตารางติดตามการชำระบัญชีบริษัทจดเลิก (ยื่น ลช.3 ทุก 3 เดือนจนเสร็จ)
create table if not exists liquidation (
  tax_id text primary key references client(tax_id),
  dissolve_date text,                      -- วันจดเลิก (พ.ศ. วว/ดด/ปปปป)
  lor3_dates jsonb not null default '[]',  -- ประวัติวันยื่น ลช.3 (ISO ค.ศ.)
  done_date text,                          -- วันเสร็จการชำระบัญชี (ว่าง = ยังไม่เสร็จ)
  blocker text,                            -- ปัญหาที่ทำให้ยังชำระบัญชีไม่เสร็จ
  next_action text,                        -- ต้องทำอะไรต่อ
  updated_at timestamptz not null default now()
);
alter table liquidation enable row level security;
drop policy if exists liquidation_rw on liquidation;
create policy liquidation_rw on liquidation for all to authenticated using (true) with check (true);
