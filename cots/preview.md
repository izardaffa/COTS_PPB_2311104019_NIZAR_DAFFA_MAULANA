## PREVIEW APLIKASI

# **Struktur Proyek Flutter**

### 📁 Struktur Folder Utama

```txt
lib/
│
├── design_system/
│   ├── colors.dart
│   ├── typography.dart
│   └── spacing.dart
│
├── data/
│   └── models/
│       └── task_model.dart
│
├── presentation/
│   ├── dashboard/
│   │   └── dashboard_page.dart
│   ├── task_list/
│   │   └── task_list_page.dart
│   ├── task_detail/
│   │   └── task_detail_page.dart
│   └── task_add/
│       └── task_add_page.dart
│
├── widgets/
│   ├── task_card.dart
│   ├── primary_button.dart
│   └── task_input.dart
│
└── main.dart
```

📌 **Catatan penting:**

- `design_system/` **WAJIB hidup**, bukan pajangan.
- `presentation/` hanya berisi UI + interaksi, bukan logika berat.
- Komponen reusable masuk ke `widgets/`.

---

# **DESIGN SYSTEM (WAJIB & KONSISTEN)**

## 🎨 `colors.dart`

```txt
Primary       : Biru Navy (#1E3A8A)
Secondary     : Biru Muda (#3B82F6)
Success       : Hijau (#22C55E)
Warning       : Oranye (#F97316)
Danger        : Merah (#EF4444)

Background    : Abu muda (#F8FAFC)
Text Primary  : Hitam pekat (#0F172A)
Text Secondary: Abu tua (#475569)
```

➡️ **Makna warna jelas**

- Status tugas langsung kebaca tanpa mikir.
- Dosen suka: ada semantik.

---

## ✍️ `typography.dart`

| Tipe      | Ukuran | Weight   | Penggunaan       |
| --------- | ------ | -------- | ---------------- |
| Heading 1 | 24     | Bold     | Judul halaman    |
| Heading 2 | 18     | SemiBold | Judul section    |
| Body      | 14     | Regular  | Konten utama     |
| Caption   | 12     | Medium   | Deadline, status |

Font: **Inter / Poppins** (aman, modern, Flutter-friendly)

---

## 📐 `spacing.dart`

```txt
xs  : 4
sm  : 8
md  : 16
lg  : 24
xl  : 32
```

➡️ Semua padding & margin **HARUS** pakai ini.
Kalau masih pakai `EdgeInsets.all(13)`, itu tanda dosa.

---

# **STATE MANAGEMENT**

### Metode: **Local State (`setState`)**

Sederhana, sesuai scope COTS.

### State Digunakan Untuk:

1. **Menambah tugas**

   - Dari Tambah Tugas → Daftar Tugas

2. **Mengubah status/detail**

   - Toggle selesai
   - Edit catatan

📌 State berada di:

- `TaskListPage`
- `TaskDetailPage`

---

# **IMPLEMENTASI 4 HALAMAN UTAMA**

---

## 🏠 1. Dashboard (Beranda)

**Isi Halaman:**

- Greeting singkat
- Ringkasan jumlah tugas:

  - Total
  - Selesai
  - Berjalan

- Shortcut button

**Komponen:**

- Card statistik
- Primary Button

➡️ Fungsi:

- Navigasi cepat
- Overview akademik (biar kelihatan produktif)

---

## 📋 2. Daftar Tugas

**Isi Halaman:**

- List Card tugas
- Warna status berbeda
- Deadline terlihat jelas

**Task Card:**

- Judul
- Mata kuliah
- Deadline
- Badge status

➡️ Scrollable, clean, tidak ribet.

---

## 🔍 3. Detail Tugas

**Isi Halaman:**

- Judul tugas
- Mata kuliah
- Deadline
- Status (Checkbox)
- Catatan (editable)

**Aksi:**

- Toggle selesai
- Update catatan

➡️ Halaman ini bukti bahwa **state benar-benar dipakai**.

---

## ➕ 4. Tambah Tugas

**Form Input:**

- Judul (required)
- Mata kuliah (required)
- Deadline (Date picker)
- Catatan (optional)

**Validasi:**

- Tidak boleh kosong
- Deadline minimal hari ini

➡️ Kalau kosong → snackbar.
User ditegur, tapi sopan.

---

# **SLICING & NAVIGASI**

### 📍 Alur Navigasi (WAJIB TERPENUHI)

✔ Dashboard → Daftar Tugas
✔ Dashboard → Detail Tugas
✔ Dashboard → Tambah Tugas
✔ Daftar Tugas → Detail Tugas
✔ Daftar Tugas → Tambah Tugas

### Teknik:

- `Navigator.push`
- Data dikirim via constructor

➡️ Tidak ada deep magic. Stabil. Aman.

---

# **PENGUJIAN & DEBUGGING**

### Checklist Lulus Aman:

✅ Input kosong tidak bisa submit
✅ Navigasi tidak crash
✅ State berubah real-time
✅ Warna & font konsisten
✅ Tampilan mendekati desain

Kalau satu gagal → nilai bisa ikut jatuh. Kita tidak mau itu.
