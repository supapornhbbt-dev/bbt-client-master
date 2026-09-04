-- แพตช์: ใส่การแบ่งชั่วโมงแบบกลุ่มตามไฟล์ Excel (หลักการปี 2569 ข้อ 4)
-- 1) กลุ่ม BC ทั้ง 7 บริษัท: Prepare แบ่ง ปุ้ย 30% / อัสมา 45% / เนย 15% / ดาด้า 10%
-- 2) AFCL: งานปิดงบแบ่ง ปุ้ย 50% / ลูกหยี 50%
-- ใช้กับทั้งปี 2569 และ 2570 — รันซ้ำได้ ไม่มีข้อมูลซ้ำ

delete from assignment
where role = 'Prepare'
  and tax_id in (select tax_id from client where client_group = 'BC');

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, 'Prepare', t.tok, t.pct, 'แบ่งกลุ่ม BC: ปุ้ย30/อัสมา45/เนย15/ดาด้า10'
from client c
cross join (values ('SUH',30),('AYS',45),('CPJ',15),('NML',10)) as t(tok,pct)
cross join (values (2569),(2570)) as y(work_year)
where c.client_group = 'BC'
on conflict do nothing;

delete from assignment
where role = 'Closing'
  and tax_id = (select tax_id from client where client_code = 'AFCL');

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, 'Closing', t.tok, t.pct, 'AFCL ปิดงบแบ่ง 50:50'
from client c
cross join (values ('SUH',50),('NTJ',50)) as t(tok,pct)
cross join (values (2569),(2570)) as y(work_year)
where c.client_code = 'AFCL'
on conflict do nothing;

-- ตรวจผล: ควรเห็นกลุ่ม BC บริษัทละ 4 คน และ AFCL Closing 2 คน ทั้งสองปี
select c.client_code as บริษัท, a.work_year as ปี, a.role as บทบาท, a.staff_token as คน, a.share_pct as เปอร์เซ็นต์
from assignment a join client c using (tax_id)
where (c.client_group = 'BC' and a.role = 'Prepare') or (c.client_code = 'AFCL' and a.role = 'Closing')
order by c.client_code, a.work_year, a.share_pct desc;
