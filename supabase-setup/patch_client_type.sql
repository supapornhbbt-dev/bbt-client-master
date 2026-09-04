-- เพิ่มประเภทลูกค้า: Account (งานทำบัญชี) / Consult (งานที่ปรึกษา)
-- ค่าเริ่มต้นทุกบริษัท = Account แล้วเข้าไปเปลี่ยนเป็น Consult เองในเว็บ
alter table client add column if not exists client_type text not null default 'Account'
  check (client_type in ('Account','Consult'));

select client_type as ประเภท, count(*) as จำนวนบริษัท from client group by client_type;
