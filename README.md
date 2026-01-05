# COTS PPB 2311104019 NIZAR DAFFA MAULANA

A Flutter app for managing tugas besar with Supabase as backend. Includes dashboard, task list, task detail, and add-task flow with loading/error handling.

## Fitur Utama

- Dashboard: statistik total/selesai, daftar tugas dengan deadline terdekat.
- Daftar tugas: search, filter status (Semua/Berjalan/Selesai/Terlambat), list tugas.
- Detail tugas: ubah status selesai/berjalan, edit & simpan catatan.
- Tambah tugas: judul, mata kuliah, deadline, catatan opsional; data tersimpan ke Supabase.
- Integrasi Supabase REST: CRUD via `TaskService`, anonKey simpan di `.env`.

## Halaman

- Dashboard: statistik dan 3 tugas terdekat yang belum selesai dengan tenggat besok.
- Daftar Tugas: list dengan search + filter; navigate ke tambah atau detail.
- Detail Tugas: status badge, info mata kuliah & deadline, toggle selesai, catatan editable, simpan perubahan.
- Tambah Tugas: form tambah tugas baru.

## Konfigurasi Environment

Buat file `.env` di root:

```
BASE_URL=https://your-project.supabase.co
ANON_KEY=your-anon-key
```

## Run Project

```
flutter pub get
flutter run
```

## Preview

- Dashboard: ![Dashboard](docs/Screenshot%202026-01-05%20104148.png)
- Daftar Tugas: ![Daftar Tugas](docs/Screenshot%202026-01-05%20104201.png)
- Detail Tugas: ![Detail Tugas](docs/Screenshot%202026-01-05%20104454.png)
- Tambah Tugas: ![Tambah Tugas](docs/Screenshot%202026-01-05%20104334.png)
