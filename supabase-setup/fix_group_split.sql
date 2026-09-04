-- แก้การแบ่งชั่วโมงกลุ่มตามชีต "หลักการคำนวณชั่วโมง" ปี 2569
-- รันในหน้า SQL Editor ครั้งเดียว (แก้ทั้งปี 2569 และ 2570)

-- 1) กลุ่ม BC: Prepare แบ่ง ปุ้ย 30% / อัสมา 45% / เนย 15% / ดาด้า 10%
delete from assignment
where role = 'Prepare' and work_year in (2569, 2570)
  and tax_id in (select tax_id from client where client_group = 'BC');

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, 'Prepare', p.tok, p.pct, 'แบ่งกลุ่ม BC ตามหลักการ 2569'
from client c
cross join (values (2569), (2570)) as y(work_year)
cross join (values ('SUH', 30), ('AYS', 45), ('CPJ', 15), ('NML', 10)) as p(tok, pct)
where c.client_group = 'BC';

-- 2) AFCL: งานปิดงบแบ่ง 50:50 ปุ้ย/ลูกหยี
delete from assignment
where role = 'Closing' and work_year in (2569, 2570)
  and tax_id in (select tax_id from client where client_code = 'AFCL');

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, 'Closing', p.tok, p.pct, 'ปิดงบแบ่ง 50:50 ตามหลักการ 2569'
from client c
cross join (values (2569), (2570)) as y(work_year)
cross join (values ('SUH', 50), ('NTJ', 50)) as p(tok, pct)
where c.client_code = 'AFCL';

-- ตรวจผล: BC ควรได้ 56 แถว (7 บริษัท × 4 คน × 2 ปี), AFCL Closing ควรได้ 4 แถว
select 'BC Prepare' as รายการ, count(*) as แถว
from assignment a join client c using (tax_id)
where c.client_group = 'BC' and a.role = 'Prepare'
union all
select 'AFCL Closing', count(*)
from assignment a join client c using (tax_id)
where c.client_code = 'AFCL' and a.role = 'Closing';
