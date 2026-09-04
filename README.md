# BBT Client Master

ระบบทะเบียนลูกค้าและตารางงานของสำนักงานบัญชี BBT — เว็บหน้าเดียวบน Cloudflare Pages ต่อกับฐานข้อมูล Supabase

## โครงสร้าง

| ที่อยู่ | คืออะไร |
|---|---|
| `webapp/index.html` | ตัวเว็บทั้งหมด (หน้าเดียว ไม่มี build step) |
| `webapp/logo.png` | โลโก้ |
| `supabase-setup/schema.sql` | โครงสร้างตารางในฐานข้อมูล |
| `supabase-setup/patch_*.sql` | สคริปต์แก้/เพิ่มโครงสร้างรายครั้ง |
| `supabase-setup/import_*.sql` | สคริปต์นำเข้าข้อมูล |
| `deploy.sh` | ดันเว็บขึ้น Cloudflare Pages |
| `SCHEMA_STATUS.md` | สรุปสถานะโครงสร้างฐานข้อมูล |

## deploy

```bash
./deploy.sh
```

ต้องมีโทเคน Cloudflare (สิทธิ์ Pages:Edit) เก็บไว้ที่ `~/.bbt-cloudflare-token` — ไฟล์นี้อยู่นอก repo โดยตั้งใจ

## ข้อมูลที่ไม่อยู่ใน repo นี้

ไฟล์ Excel/CSV ข้อมูลลูกค้า และดัมป์ฐานข้อมูล ถูกกันไว้ใน `.gitignore` — เก็บไว้ในเครื่องเท่านั้น

**repo นี้เป็น private และมีชื่อลูกค้าจริงอยู่** ใน `supabase-setup/bbt_setup_all.sql` (seed 286 ราย) และ `BBT-redesign-mocks.html` (ตัวอย่างหน้าจอ) — ห้ามเปลี่ยน repo เป็น public และระวังตอนเชิญ collaborator

คีย์ Supabase ในโค้ดเป็น publishable key ฝั่งหน้าบ้าน การกันสิทธิ์เข้าถึงข้อมูลพึ่ง RLS บนฐานข้อมูลเป็นหลัก
