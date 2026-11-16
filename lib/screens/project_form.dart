import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman form untuk menambahkan project baru.
/// Field dan validasinya mengikuti model Project di API Django (/api/v1/projects/).
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  static const String _defaultCategory = 'web';

  static const Map<String, String> _categories = {
    'mobile': 'Mobile',
    'web': 'Web',
    'desain': 'Desain',
  };

  String _title = "";
  String _image = "";
  String _githubUrl = "";
  String _demoUrl = "";
  int? _year;
  String _category = _defaultCategory;

  /// Dekorasi input yang sama untuk semua field, agar tidak ditulis berulang.
  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.red, width: 1.5),
      ),
    );
  }

  /// Cek apakah teks adalah URL http(s) yang valid.
  bool _isHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Validasi untuk field URL
  String? _validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_isHttpUrl(value.trim())) {
      return "Masukkan URL yang valid (diawali http:// atau https://).";
    }
    return null;
  }

  /// Mengosongkan form dan variabel penampung input.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = "";
      _image = "";
      _githubUrl = "";
      _demoUrl = "";
      _year = null;
      _category = _defaultCategory;
    });
  }

  String _orDash(String value) => value.isEmpty ? "-" : value;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Project', style: AppTextStyles.logo),
        titleSpacing: 0,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Project (wajib, maks. 225 karakter) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Nama Project",
                    hint: "Contoh: Portfolio Web",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!.trim();
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama project tidak boleh kosong!";
                    }
                    if (value.trim().length > 225) {
                      return "Nama project maksimal 225 karakter.";
                    }
                    return null;
                  },
                ),
              ),

              // === Kategori ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Kategori"),
                  dropdownColor: AppColors.carbonBlack,
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Tahun (opsional, 2000 - tahun berjalan) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Tahun (opsional)",
                    hint: "Contoh: $currentYear",
                  ),
                  keyboardType: TextInputType.number,
                  // Hanya angka yang bisa diketik.
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String? value) {
                    setState(() {
                      _year = int.tryParse(value ?? "");
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return null;
                    final year = int.tryParse(value);
                    if (year == null || year < 2000 || year > currentYear) {
                      return "Tahun harus antara 2000 dan $currentYear.";
                    }
                    return null;
                  },
                ),
              ),

              // === Gambar (opsional, path file atau URL http(s)) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Gambar (opsional)",
                    hint: "URL gambar atau link Google Drive",
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (String? value) {
                    setState(() {
                      _image = value!.trim();
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final text = value.trim();
                    if (!text.startsWith('/') && !_isHttpUrl(text)) {
                      return "Gambar harus berupa path file atau URL http(s)://.";
                    }
                    return null;
                  },
                ),
              ),

              // === GitHub URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "GitHub URL (opsional)",
                    hint: "https://github.com/...",
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (String? value) {
                    setState(() {
                      _githubUrl = value!.trim();
                    });
                  },
                  validator: _validateOptionalUrl,
                ),
              ),

              // === Demo URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Demo URL (opsional)",
                    hint: "https://...",
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (String? value) {
                    setState(() {
                      _demoUrl = value!.trim();
                    });
                  },
                  validator: _validateOptionalUrl,
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Project berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Project: $_title'),
                                    Text('Kategori: ${_categories[_category]}'),
                                    Text('Tahun: ${_year ?? "-"}'),
                                    Text('Gambar: ${_orDash(_image)}'),
                                    Text('GitHub: ${_orDash(_githubUrl)}'),
                                    Text('Demo: ${_orDash(_demoUrl)}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetForm();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
