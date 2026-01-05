# Tugas Besar - Task Manager Application

Aplikasi Flutter untuk manajemen tugas akademik dengan antarmuka yang modern dan user-friendly.

## 📱 Fitur Utama

### 1. **Dashboard (Beranda)**

- Tampilan ringkasan jumlah tugas (Total, Selesai)
- Greeting untuk pengguna
- Shortcut ke halaman Daftar Tugas dan Tambah Tugas
- Menampilkan tugas terdekat (upcoming task)

### 2. **Daftar Tugas (Task List)**

- Lihat semua tugas dalam satu halaman
- Fitur pencarian berdasarkan judul atau mata kuliah
- Filter berdasarkan status: Semua, Berjalan, Selesai, Terlambat
- Status tugas ditampilkan dengan warna yang berbeda (semantic colors)
- Akses cepat ke form tambah tugas

### 3. **Detail Tugas (Task Detail)**

- Tampilan lengkap informasi tugas
- Edit catatan/notes untuk tugas
- Toggle status tugas (Berjalan ↔ Selesai)
- Informasi deadline dan mata kuliah
- Simpan perubahan dengan mudah

### 4. **Tambah Tugas (Task Add)**

- Form input untuk membuat tugas baru
- Validasi input:
  - Judul wajib diisi (minimal 5 karakter)
  - Mata kuliah wajib diisi
  - Deadline minimal hari ini
  - Catatan bersifat optional
- Date picker untuk memilih deadline
- Feedback visual saat tugas berhasil ditambahkan

## 🎨 Design System

### Warna (Colors)

```
PRIMARY       : #2F6BFF (Biru cerah)
PRIMARY DARK  : #1E3A8A (Biru navy)
PRIMARY LIGHT : #3B82F6 (Biru muda)

SUCCESS  : #22C55E (Hijau)
WARNING  : #F97316 (Oranye)
DANGER   : #EF4444 (Merah)

BACKGROUND  : #F8FAFC (Abu muda)
SURFACE     : #FFFFFF (Putih)
TEXT PRIMARY   : #0F172A (Hitam pekat)
TEXT SECONDARY : #475569 (Abu tua)
BORDER      : #E2E8F0 (Abu muda border)
```

### Typography

| Tipe      | Ukuran | Weight   | Penggunaan    |
| --------- | ------ | -------- | ------------- |
| Heading 1 | 24     | Bold     | Judul halaman |
| Heading 2 | 18     | SemiBold | Judul section |
| Title     | 16     | SemiBold | Judul card    |
| Body      | 14     | Regular  | Konten utama  |
| Caption   | 12     | Regular  | Info kecil    |
| Button    | 14     | Medium   | Tombol text   |

### Spacing

```
xs  :  4 px
sm  :  8 px
md  : 16 px
lg  : 24 px
xl  : 32 px
xxl : 40 px
```

## 📁 Struktur Folder

```
lib/
├── main.dart                          # Entry point aplikasi
├── design_system/                     # Design system terpusat
│   ├── app_colors.dart               # Definisi warna
│   ├── typography.dart               # Definisi typography
│   └── spacing.dart                  # Definisi spacing
├── data/
│   └── models/
│       └── task_model.dart           # Model Task
├── presentation/                      # UI Pages
│   ├── dashboard/
│   │   └── dashboard_page.dart       # Halaman beranda
│   ├── task_list/
│   │   └── task_list_page.dart       # Halaman daftar tugas
│   ├── task_detail/
│   │   └── task_detail_page.dart     # Halaman detail tugas
│   └── task_add/
│       └── task_add_page.dart        # Halaman tambah tugas
└── widgets/                           # Reusable widgets
    ├── primary_button.dart           # Button utama
    ├── task_card.dart                # Card untuk task
    ├── task_input.dart               # Input field
    └── statistic_card.dart           # Card statistik
```

## 🔄 State Management

Aplikasi ini menggunakan **Local State** dengan `setState()` untuk manajemen state yang sederhana dan sesuai dengan scope proyek.

### State Location:

- **DashboardPage**: Menyimpan daftar tasks
- **TaskListPage**: Mengelola filter dan search
- **TaskDetailPage**: Menghandle edit catatan dan status
- **TaskAddPage**: Mengelola form input

## 🚀 Navigasi

Alur navigasi yang tersedia:

- Dashboard → Daftar Tugas
- Dashboard → Detail Tugas (dari upcoming task)
- Dashboard → Tambah Tugas
- Daftar Tugas → Detail Tugas
- Daftar Tugas → Tambah Tugas

Navigasi menggunakan `Navigator.push()` dengan data yang dikirim via constructor.

## 📋 Task Model

```dart
class Task {
  final String id;
  final String judul;
  final String mataKuliah;
  final DateTime deadline;
  final String? catatan;
  TaskStatus status;  // berjalan, selesai, terlambat
}

enum TaskStatus {
  berjalan,
  selesai,
  terlambat,
}
```

## ✅ Checklist Fitur

- ✅ Input kosong tidak bisa submit (validasi)
- ✅ Navigasi tidak crash
- ✅ State berubah real-time
- ✅ Warna & font konsisten (Design System)
- ✅ Tampilan sesuai preview/desain
- ✅ Search & filter berfungsi
- ✅ Date picker untuk deadline
- ✅ Responsive dan user-friendly

## 🛠️ Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0 # Untuk format tanggal
```

## 🚀 Cara Menjalankan

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Run aplikasi:

   ```bash
   flutter run
   ```

3. Untuk build:
   ```bash
   flutter build apk      # Android
   flutter build ios      # iOS
   ```

## 📝 Notes

- Semua komponen reusable ada di `widgets/`
- Design System harus konsisten dan tidak boleh di-hardcode
- Setiap halaman adalah stateful widget untuk mengelola local state
- Tidak ada backend/API, menggunakan in-memory data
- Responsive design untuk berbagai ukuran layar

---

**Dibuat oleh:** Nizar Daffa Maulana
**Tanggal:** Januari 2026
