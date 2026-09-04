-- 29 ส.ค. 2569: ยกเลิกทีมแบ่ง % ของ AFCL และ TGN ตามคำสั่งผู้ใช้
-- AFCL: YEE (NTJ) ทำทั้ง Prepare และ Closing คนเดียว — ปุ้ยช่วยเรื่องวางระบบ (ยังเป็น Supervisor เหมือนเดิม)
-- TGN:  Prepare = BONUS (SKC) คนเดียว | Closing = PUI (SUH) 100% มีอยู่แล้ว ไม่แตะ
-- ชั่วโมงแบ่งตามสูตรบทบาทปกติ (Prepare 65/75%, Closing 25%) | ใช้กับปี 2569 และ 2570

delete from assignment
where work_year in (2569, 2570)
  and ((tax_id = (select tax_id from client where client_code = 'AFCL') and role in ('Prepare','Closing'))
    or (tax_id = (select tax_id from client where client_code = 'TGN') and role = 'Prepare'));

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, m.role, m.tok, 100, 'ยกเลิกแบ่ง % 29 ส.ค. 2569'
from (values ('AFCL','Prepare','NTJ'), ('AFCL','Closing','NTJ'), ('TGN','Prepare','SKC')) as m(code, role, tok)
join client c on c.client_code = m.code
cross join (values (2569),(2570)) as y(work_year);

select c.client_code, a.work_year, a.role, a.staff_token, a.share_pct
from assignment a join client c using (tax_id)
where c.client_code in ('AFCL','TGN')
order by c.client_code, a.work_year, a.role;
