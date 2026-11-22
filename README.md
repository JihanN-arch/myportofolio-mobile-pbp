# Portfolio Mobile - Tugas PBP

**Nama:** Jihan Nabiilah P.S  
**NPM:** 2506549026  
**Kelas:** PBP C

---

## 📝 Jawaban Pertanyaan Reflektif (Tugas 7)

### 1. Apa Itu _Widget Tree_ dan Bagaimana Hubungan _Parent-Child_ Bekerja?

- **Konsep _Widget Tree_:**  
  Di Flutter, semua tampilan dibangun dari _widget_ yang disusun bertingkat sehingga membentuk struktur pohon, yaitu **_widget tree_**. Gampangnya, mirip DOM di HTML: setiap _widget_ adalah sebuah _node_, kayak `<div>` yang isinya `<div>` lain. Contoh dari proyek ini:

```
  MaterialApp
  └── MyHomePage
      └── Scaffold
          ├── AppBar
          │   └── Text("JIHAN")
          └── SingleChildScrollView
              └── Column
                  ├── HeroSection
                  ├── Row
                  │   ├── InfoCard (NPM)
                  │   ├── InfoCard (Jurusan)
                  │   └── InfoCard (Class)
                  └── Wrap
                      └── ItemCard × 5
```

- **Cara Kerja Hubungan _Parent-Child_:**  
  _Parent_ membungkus _child_ lewat properti `child` (satu anak) atau `children` (banyak anak). Misalnya, `Padding` cuma punya satu `child`, sedangkan `Column` dan `Row` punya `children`. _Parent_ juga yang mengatur ukuran dan posisi _child_: _parent_ memberi batas ukuran (_constraints_), _child_ menentukan ukurannya sendiri di dalam batas itu, lalu _parent_ yang menempatkannya. Contohnya, `Expanded` di dalam `Row` bikin ketiga `InfoCard` membagi lebar layar sama rata.
- **Pewarisan Data ke Bawah:**  
  Awalnya saya kira kalau _color_ di _parent_ diubah, _child_-nya otomatis ikut, kayak di CSS. Ternyata tidak begitu. Properti visual seperti `color` pada `Container` **tidak diturunkan** ke _child_; _child_ cuma kelihatan ikut berwarna karena dia digambar di atas _background_ _parent_. Yang benar-benar diwariskan ke bawah adalah data dari _widget_ khusus seperti `Theme`. Makanya tema yang diatur di `MaterialApp` bisa dipakai semua _widget_ di bawahnya lewat `Theme.of(context)`, kecuali _widget_ yang mengatur `style` atau `color`-nya sendiri.

### 2. _Widget_ Apa Saja yang Dipakai dan Apa Fungsinya?

Umm jujur banyak bet _widget_ yang kepakai, ini daftarnya:

| _Widget_                                                                  | Fungsi                                                                                        |
| ------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `MaterialApp`                                                             | _Root_ aplikasi. Mengatur tema, judul, dan halaman pertama.                                   |
| `Scaffold`                                                                | Kerangka dasar halaman: tempat `AppBar`, `body`, dan _SnackBar_.                              |
| `AppBar`                                                                  | Bar judul di bagian atas halaman.                                                             |
| `Text` / `Text.rich` + `TextSpan`                                         | Menampilkan teks. `Text.rich` dipakai agar satu baris bisa berisi beberapa warna (_tagline_). |
| `Column`                                                                  | Menyusun _widget_ secara vertikal.                                                            |
| `Row`                                                                     | Menyusun _widget_ secara horizontal (tiga `InfoCard`).                                        |
| `Expanded`                                                                | Membuat _child_ mengisi sisa ruang di `Row`, sehingga ketiga kartu sama lebar.                |
| `IntrinsicHeight`                                                         | Menyamakan tinggi ketiga `InfoCard`.                                                          |
| `SizedBox`                                                                | Memberi jarak kosong antar-_widget_ atau ukuran tetap.                                        |
| `Padding`                                                                 | Memberi ruang di sekitar _child_.                                                             |
| `Center`                                                                  | Menempatkan _child_ di tengah.                                                                |
| `SingleChildScrollView`                                                   | Membuat halaman bisa di-_scroll_ agar tidak _overflow_ di layar kecil.                        |
| `Container` + `BoxDecoration`                                             | Kotak dengan _background_, sudut membulat, dan garis tepi (`InfoCard`).                       |
| `LayoutBuilder`                                                           | Mengambil lebar layar yang tersedia untuk menghitung lebar tiap tombol.                       |
| `Wrap`                                                                    | Menyusun tombol menjadi beberapa baris secara otomatis.                                       |
| `Material`                                                                | Memberi warna latar dan bentuk pada `ItemCard`, sekaligus tempat efek riak (_ripple_).        |
| `InkWell`                                                                 | Membuat kartu bisa ditekan (`onTap`) dengan efek riak.                                        |
| `Icon`                                                                    | Menampilkan ikon di tombol.                                                                   |
| `SnackBar`                                                                | Pesan singkat di bawah layar, ditampilkan lewat `ScaffoldMessenger`.                          |
| `Navigator` + `MaterialPageRoute`                                         | Berpindah ke halaman Projects, Expertise, dan Experience.                                     |
| `ElevatedButton`                                                          | Tombol "Tambah ..." di halaman _placeholder_.                                                 |
| `MyHomePage`, `HeroSection`, `InfoCard`, `ItemCard`, `SectionPlaceholder` | _Widget_ buatan sendiri (`StatelessWidget`) yang menyusun _widget-widget_ di atas.            |

### 3. Apa Fungsi `MaterialApp` dan Kenapa Jadi _Root Widget_?

- **Fungsi `MaterialApp`:**  
  `MaterialApp` adalah _widget_ pembungkus yang menyiapkan semua kebutuhan aplikasi bergaya **Material Design**. Di dalamnya sudah tersedia **tema** (warna, _font_, dan gaya bawaan), **`Navigator`** untuk perpindahan halaman, **`ScaffoldMessenger`** yang memungkinkan _SnackBar_ muncul, **`MediaQuery`** untuk informasi ukuran layar, serta pengaturan lain seperti lokalisasi, `title`, dan `debugShowCheckedModeBanner`.
- **Kenapa Dijadikan _Root_:**  
  Semua fitur di atas harus tersedia **dari paling atas** supaya bisa dipakai oleh seluruh _widget_ di bawahnya. Di proyek ini, `Theme.of(context)`, `Navigator.push`, dan `ScaffoldMessenger.of(context)` cuma bisa jalan karena ada `MaterialApp` di atasnya. Tanpa `MaterialApp`, _widget_ seperti `Scaffold`, `AppBar`, dan `SnackBar` tidak bisa bekerja dengan normal.

### 4. Apa Bedanya `StatelessWidget` dan `StatefulWidget`?

- **`StatelessWidget`:**  
  _Widget_ yang **tidak punya _state_** (data internal yang bisa berubah). Tampilannya cuma bergantung pada data yang diberikan saat _widget_ dibuat dan tidak berubah dengan sendirinya. Contohnya `MyHomePage`, `InfoCard`, dan `ItemCard` di proyek ini, karena data NPM, nama, kelas, dan daftar tombolnya tetap.
- **`StatefulWidget`:**  
  _Widget_ yang **punya objek `State`** untuk menyimpan data yang bisa berubah. Ketika data berubah lewat `setState()`, Flutter memanggil ulang `build()` sehingga tampilannya ikut diperbarui. Contohnya _counter_, _checkbox_, _form input_, atau daftar yang bisa ditambah dan dihapus.
- **Kapan Pakai yang Mana:**  
  Pakai `StatelessWidget` kalau tampilannya cuma menampilkan data yang tidak berubah, karena lebih sederhana dan ringan. Pakai `StatefulWidget` kalau tampilan harus berubah karena interaksi pengguna atau data baru. Nanti waktu bikin fitur CRUD untuk Projects dan Experience, saya bakal butuh `StatefulWidget`, karena daftarnya harus ter-_update_ setelah item ditambah, diubah, atau dihapus, dan _form_ tambah item perlu menyimpan _input_ pengguna.

### 5. Apa Itu `BuildContext` dan Kenapa Penting?

- **Pengertian `BuildContext`:**  
  `BuildContext` adalah **penanda posisi sebuah _widget_ di dalam _widget tree_**. Setiap _widget_ punya _context_-nya sendiri, dan _context_ ini diberikan ke method `build(BuildContext context)`.
- **Kenapa Penting dan Cara Pakainya:**  
  _Context_ dipakai untuk **mencari dan mengakses data dari _widget_ di atasnya (_ancestor_)**. Pola `X.of(context)` artinya "mulai dari posisi _widget_ ini, cari _widget_ `X` terdekat di atasnya". Contoh di proyek ini:

```dart
  Theme.of(context)                 // mengambil tema dari MaterialApp
  ScaffoldMessenger.of(context)     // menampilkan SnackBar
  Navigator.push(context, ...)      // pindah halaman
  MediaQuery.of(context).size       // ukuran layar
```

Karena sifatnya mencari ke atas, _context_ harus berasal dari _widget_ yang memang berada di bawah _widget_ yang dicari. Misalnya, `ScaffoldMessenger.of(context)` cuma berhasil kalau _widget_-nya ada di bawah `MaterialApp`.

### 6. Apa Bedanya _Hot Reload_ dan _Hot Restart_?

- **_Hot Reload_ (`r`):**  
  Menyuntikkan kode yang diubah ke aplikasi yang sedang berjalan, lalu menjalankan ulang `build()`. Prosesnya sangat cepat dan **_state_ tetap terjaga**. Misalnya kalau _counter_ sedang bernilai 5, nilainya tetap 5 setelah _reload_. Cocok buat ngubah tampilan seperti warna, teks, _padding_, dan _layout_.
- **_Hot Restart_ (`R`):**  
  Menjalankan ulang aplikasi dari awal (`main()`) tanpa _build_ ulang dari nol. Lebih lambat dari _hot reload_, dan **_state_ hilang** alias kembali ke kondisi awal.
- **_Full Restart_ (stop, lalu `flutter run` lagi):**  
  Mem-_build_ ulang seluruh aplikasi, termasuk bagian _native_ (Android/iOS).
- **Kapan _Hot Reload_ Tidak Cukup:**  
  _Hot restart_ diperlukan kalau yang diubah adalah kode yang cuma berjalan sekali di awal, misalnya isi `main()`, nilai awal variabel _global/static_, `initState()`, atau mengubah `StatelessWidget` menjadi `StatefulWidget`. Sementara itu, _full restart_ diperlukan kalau yang diubah ada di luar kode Dart, misalnya menambah _package_ atau _plugin_ di `pubspec.yaml`, menambah _asset_ baru seperti gambar dan _font_, atau mengubah file _native_ seperti `AndroidManifest.xml`.

---

## 📝 Jawaban Pertanyaan Reflektif (Tugas 8)

### 1. Apa Bedanya `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`?

- **Konsep Navigasi Berbasis _Stack_:**  
  Flutter menggunakan konsep navigasi berbasis _stack_, yaitu halaman yang dibuka akan ditumpuk di atas halaman sebelumnya. Contoh dari proyek ini:

```
  push dari kartu aksi:        pushReplacement dari Drawer:

  [Tambah Experience]          [Home]   ← Tambah Experience diganti
  [Home]
```

- **`Navigator.push()`:**  
  Membuka halaman baru tanpa menghapus halaman sebelumnya, sehingga pengguna dapat kembali ke halaman sebelumnya.
- **`Navigator.pushReplacement()`:**  
  Mengganti halaman yang sedang aktif dengan halaman baru agar tidak terjadi penumpukan halaman.
- **`Navigator.pop()`:**  
  Menutup halaman atau dialog yang sedang aktif dan kembali ke tampilan sebelumnya.
- **Penerapan di Aplikasi Ini:**  
  `Navigator.push()` digunakan untuk membuka formulir melalui kartu aksi. Sementara itu, `Navigator.pushReplacement()` digunakan pada navigasi _Drawer_, termasuk menu **Home**, agar halaman sebelumnya digantikan dan tidak menumpuk. Jika pengguna sudah berada di Home, _Drawer_ cukup ditutup. `Navigator.pop()` digunakan untuk menutup dialog ringkasan atau keluar dari formulir melalui tombol Batal.

### 2. Bagaimana `Scaffold`, `AppBar`, dan `Drawer` Menjaga Struktur Halaman Tetap Konsisten?

- **Peran `Scaffold`:**  
  `Scaffold` merupakan kerangka dasar halaman Flutter yang menyediakan slot seperti `appBar`, `drawer`, dan `body`. Dengan demikian, komponen halaman dapat disusun lebih teratur dan konsisten.
- **Menjaga Konsistensi:**  
  Setiap halaman, yaitu Home, Tambah Project, dan Tambah Experience, menggunakan `AppBar` dengan gaya yang sama dan `LeftDrawer` yang sama, sehingga tampilan dan navigasinya seragam. Karena `LeftDrawer` adalah satu _widget_ yang dipakai ulang, perubahan pada _Drawer_ cukup dilakukan di satu file.
- **Contoh Warna Tema:**  
  Warna merah portofolio `AppColors.red` (`#CF0F47`) digunakan pada garis bawah `AppBar` di halaman Home dan Tambah Project, tombol Simpan di formulir Project, dan indikator menu aktif di _Drawer_. Penggunaan kelas `AppColors` membuat pengelolaan warna lebih praktis tanpa harus menuliskan kode hex berulang kali.

### 3. Kenapa Tata Letak Formulir Dipilih Seperti Ini?

- **Alasan Tata Letak:**  
  Formulir menggunakan `Column` untuk menyusun _field_ secara vertikal agar mudah diikuti, terutama pada layar _smartphone_. Pengguna cukup mengisi dari atas ke bawah, lalu tombol Batal dan Simpan berada di akhir.
- **_Widget_ Pengatur Jarak:**  
  `Padding` memberi ruang di sekitar setiap _field_, dan `SizedBox` memberi jarak di antara tombol Batal dan Simpan, sehingga tampilan lebih rapi dan tidak terlalu padat.
- **_Widget_ Penggulir:**  
  `SingleChildScrollView` memungkinkan pengguna menggulir formulir ketika konten melebihi ukuran layar atau ketika _keyboard_ muncul. Dengan begitu, seluruh _field_ dan tombol tetap dapat diakses.

### 4. Apa Peran `GlobalKey<FormState>`, `validator`, dan `validate()`?

- **`GlobalKey<FormState>`:**  
  Digunakan untuk mengakses _state_ dari `Form`, sehingga fungsi seperti `validate()` dapat dipanggil.
- **`validator`:**  
  Fungsi untuk memeriksa apakah input sudah memenuhi aturan. Jika tidak valid, fungsi ini mengembalikan pesan kesalahan; jika valid, mengembalikan `null`.
- **`validate()`:**  
  Menjalankan seluruh `validator` dalam `Form` dan mengembalikan `true` hanya jika semua input valid. Ketika tombol Simpan ditekan, `validate()` akan memeriksa seluruh input. Jika terdapat input yang tidak valid, pesan kesalahan akan ditampilkan dan dialog ringkasan tidak akan muncul.
- **Contoh Nilai yang Ditolak:**  
  _Field_ Tahun pada formulir Project hanya menerima tahun antara 2000 dan tahun berjalan. Jika pengguna memasukkan `1999`, validator akan menolaknya meskipun input tersebut berupa angka.
- **Kenapa Jenis Input Saja Belum Cukup:**  
  _Keyboard_ angka dan filter digit hanya membatasi karakter yang dimasukkan, tetapi tidak memastikan nilainya sesuai aturan aplikasi. Oleh karena itu, validator tetap diperlukan untuk memastikan data yang dimasukkan benar dan sesuai ketentuan.

---

## 🤖 AI Disclosure & Reflection

Dalam pengerjaan Tugas 7 dan Tugas 8 ini, saya memanfaatkan AI (**Claude** dan **Gemini**) sebagai _learning partner_ dan alat bantu teknis. Berikut adalah rincian pemanfaatannya:

### 1. Strategi Prompting (_Prompting Strategy_)

Saya menggunakan teknik **_iterative prompting_** dan **_context-based debugging_**. Alih-alih meminta AI untuk membuat seluruh kode dari nol, saya menyusun kerangka kode secara mandiri, lalu berkonsultasi mengenai potongan kode yang bermasalah atau alur yang belum sesuai untuk mendapatkan penjelasan konseptual serta solusi perbaikannya.

### 2. Pembagian Kontribusi: AI vs. Penulisan Mandiri

- **Bantuan AI:**
  - Diskusi format _Conventional Commits_ (seperti penggunaan _prefix_ `feat`, `fix`, `style`, dsb.).
  - _Troubleshooting_ kendala _staging_ dan penanganan konflik Git.
  - Penyediaan referensi logika serta penjelasan alternatif untuk sintaks atau alur kode yang belum dipahami.
  - Parafrase dan penyuntingan kalimat refleksi agar terdengar lebih rapi dan profesional.
  - Penyusunan struktur dan tata letak dokumentasi (_README_) agar lebih mudah dibaca.

- **Pengerjaan Mandiri:**
  - Penulisan seluruh struktur kode utama dari awal hingga akhir.
  - Implementasi akhir tampilan visual, skema warna, dan pemilihan aset proyek.
  - Penyesuaian akhir logika program, integrasi antar-komponen, serta _refactoring_ gaya tampilan agar sesuai kebutuhan aplikasi.
- Jawaban untuk pertanyaan refleksi

### 3. Analisis Kritis & Refleksi Personal

Jujur, dalam pengerjaan Tugas 7 ini saya cukup sering berdiskusi dengan AI untuk membantu merapikan struktur kode, memparafrase jawaban refleksi, serta menanyakan terkait sintaks atau konsep yang masih membingungkan. Proses belajar ini berjalan secara interaktif (_bolak-balik_ bertanya) untuk memastikan saya benar-benar memahami logika di balik setiap solusi yang diterapkan.

Nah sebenarnya dalam pengerjaan Tugas 8 ini, penggunaan AI masih sama seperti tugas-tugas sebelumnya. Saya memanfaatkannya untuk membantu merapikan struktur kode, memahami sintaks maupun konsep yang masih membingungkan, serta memparafrase jawaban refleksi agar lebih terstruktur. Prosesnya dilakukan secara interaktif melalui diskusi dan tanya jawab secara berulang untuk memastikan bahwa saya tidak hanya mendapatkan solusi, tetapi juga memahami logika di balik penerapannya. Secara keseluruhan, tidak ada perubahan yang signifikan dalam cara saya menggunakan AI dibandingkan dengan tugas sebelumnya.

> _(Catatan Evaluator: Rincian spesifik mengenai bagian kode yang mendapat bantuan AI juga telah saya tandai menggunakan komentar langsung di dalam berkas kode terkait)._

---
