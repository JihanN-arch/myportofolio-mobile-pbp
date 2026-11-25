import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/form_decoration.dart';
import 'package:myportofolio_mobile/widgets/form_dialogs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;

  /// Dekorasi input yang sama untuk semua field, agar tidak ditulis berulang.
  InputDecoration _inputDecoration(String label, {String? hint}) {
    return appInputDecoration(label, accent: AppColors.red, hint: hint);
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

  bool get _isDirty =>
      _title.isNotEmpty ||
      _image.isNotEmpty ||
      _githubUrl.isNotEmpty ||
      _demoUrl.isNotEmpty ||
      _year != null ||
      _category != _defaultCategory;

  String? _nullIfEmpty(String value) => value.isEmpty ? null : value;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Menampilkan ringkasan data yang sudah tersimpan di server.
  void _showSummaryDialog(Project project) {
    showSummaryDialog(
      context,
      title: 'Project berhasil ditambahkan!',
      accent: AppColors.red,
      items: [
        SummaryItem(Icons.folder_outlined, 'Nama Project', project.title),
        SummaryItem(
          Icons.category_outlined,
          'Kategori',
          project.categoryDisplay.isEmpty
              ? (_categories[project.category] ?? project.category)
              : project.categoryDisplay,
        ),
        SummaryItem(
          Icons.calendar_today_outlined,
          'Tahun',
          '${project.year ?? "-"}',
        ),
        SummaryItem(Icons.image_outlined, 'Gambar', project.image ?? '-'),
        SummaryItem(Icons.code_rounded, 'GitHub', project.githubUrl ?? '-'),
        SummaryItem(Icons.open_in_new_rounded, 'Demo', project.demoUrl ?? '-'),
      ],
      onClose: _resetForm,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final apiClient = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    final token = auth.token;
    if (token == null) return;

    final newProject = Project(
      title: _title,
      category: _category,
      year: _year,
      image: _nullIfEmpty(_image),
      githubUrl: _nullIfEmpty(_githubUrl),
      demoUrl: _nullIfEmpty(_demoUrl),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await apiClient.createProject(newProject, token: token);
      if (!mounted) return;
      _showSummaryDialog(created);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        // Token sudah tidak berlaku: logout, lalu minta login ulang.
        await auth.logout();
        if (!mounted) return;
        _showSnackBar(e.userMessage);
        final again = await ensureLoggedIn(context);
        if (again && mounted) {
          _showSnackBar('Login berhasil. Tekan Simpan sekali lagi.');
        }
      } else {
        if (!mounted) return;
        _showSnackBar(e.userMessage);
      }
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Tidak bisa terhubung ke server.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) confirmLeaveForm(context);
      },
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
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
      drawer: const LeftDrawer(current: DrawerDestination.addProject),
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
                child: AppSelectField(
                  label: "Kategori",
                  accent: AppColors.red,
                  options: _categories,
                  value: _category,
                  onChanged: (String newValue) {
                    setState(() {
                      _category = newValue;
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

              // === Tombol Batal dan Simpan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.muted),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onPressed: () => cancelForm(context, isDirty: _isDirty),
                      child: const Text(
                        "Batal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.red.withAlpha(120),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Text(
                              "Simpan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
