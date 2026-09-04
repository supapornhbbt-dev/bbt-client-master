-- 29 ส.ค. 2569: ยกเลิกการแบ่ง Prepare กลุ่ม BC แบบ 4 คน (AYS45/SUH30/CPJ15/NML10)
-- เปลี่ยนเป็นคนเดียวต่อบริษัทตามคำสั่งผู้ใช้: BC=AYS(อัสมา) | ATCE,MRS,PPS=CPJ(เนย) | JSR,BAFX,SEVEN=SUH(ปุ้ย)
-- ใช้กับปี 2569 และ 2570

delete from assignment
where role = 'Prepare' and work_year in (2569, 2570)
  and tax_id in (select tax_id from client where client_code in ('BC','ATCE','MRS','PPS','JSR','BAFX','SEVEN'));

insert into assignment (work_year, tax_id, role, staff_token, share_pct, source_note)
select y.work_year, c.tax_id, 'Prepare', m.tok, 100, 'แยกรายบริษัท 29 ส.ค. 2569'
from client c
join (values ('BC','AYS'),('ATCE','CPJ'),('MRS','CPJ'),('PPS','CPJ'),('JSR','SUH'),('BAFX','SUH'),('SEVEN','SUH')) as m(code, tok)
  on c.client_code = m.code
cross join (values (2569),(2570)) as y(work_year);

select c.client_code, a.work_year, a.staff_token, a.share_pct
from assignment a join client c using (tax_id)
where c.client_group = 'BC' and a.role = 'Prepare'
order by c.client_code, a.work_year;
