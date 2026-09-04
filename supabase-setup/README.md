# ชุดติดตั้งฐานข้อมูล BBT Client Master บน Supabase

สร้างจากไฟล์ "BBT - Client Master Database.xlsx" ณ 19 ก.ค. 2569

## ไฟล์ในโฟลเดอร์นี้

- `schema.sql` — โครงตาราง 10 ตาราง + ฟังก์ชัน copy_year (สร้างปีใหม่จากปีก่อน) + สิทธิ์การเข้าถึง
- `client.csv` (212), `business_nature.csv` (15), `service_job.csv` (637), `task_template.csv` (18), `coa_mapping.csv` (12), `staff.csv` (20), `assignment.csv` (866), `workload_year.csv` (212), `financial_period.csv` (1) — ข้อมูลตั้งต้น

## ขั้นตอน (ทำครั้งเดียว)

1. สมัคร https://supabase.com (ฟรี ไม่ต้องใช้บัตรเครดิต — ล็อกอินด้วย Google ได้)
2. กด New project ตั้งชื่อ เช่น `bbt-client-master` เลือก region Singapore
3. แจ้ง Claude ว่าพร้อมแล้ว — ที่เหลือ (รัน schema, import ข้อมูล, สร้างเว็บ, เพิ่มผู้ใช้ 4 คน) Claude ทำต่อให้

ผู้ใช้: Partner 3 คน + Admin 1 คน (ตาราง app_user, role: partner/admin)
