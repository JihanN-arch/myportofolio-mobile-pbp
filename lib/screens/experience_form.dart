import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/app_text_styles.dart';
import 'package:myportofolio_mobile/widgets/form_decoration.dart';
import 'package:myportofolio_mobile/widgets/form_dialogs.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

// field fn aturan validasi, ini ikutin kek di Django
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // kunci unutk akses state form
  final _formKey = GlobalKey<FormState>();

  // buat date
  final _startedController = TextEditingController();
  final _endedController = TextEditingController();

  static const String _defaultCategory = 'full-time';

  // pilihan kategori
  static const Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  String _title = "";
  String _description = "";
  String _category = _defaultCategory;
  DateTime? _startedAt;
  DateTime? _endedAt;

  @override
  void dispose() {
    _startedController.dispose();
    _endedController.dispose();
    super.dispose();
  }

  // ubah DateTime
  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  // input decoration
  InputDecoration _inputDecoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return appInputDecoration(
      label,
      accent: AppColors.green,
      hint: hint,
      suffixIcon: suffixIcon,
    );
  }

  // data picker
  Future<void> _pickStartedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startedAt ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal mulai',
    );
    if (picked == null) return; // pengguna menekan Cancel

    setState(() {
      _startedAt = picked;
      _startedController.text = _formatDate(picked);
    });
  }

  /// Membuka date picker untuk tanggal selesai.
  Future<void> _pickEndedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? _startedAt ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal selesai',
    );
    if (picked == null) return;

    setState(() {
      _endedAt = picked;
      _endedController.text = _formatDate(picked);
    });
  }

  // kosongin data akhr
  void _clearEndedDate() {
    setState(() {
      _endedAt = null;
      _endedController.clear();
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _startedController.clear();
    _endedController.clear();
    setState(() {
      _title = "";
      _description = "";
      _category = _defaultCategory;
      _startedAt = null;
      _endedAt = null;
    });
  }

  bool get _isDirty =>
      _title.isNotEmpty ||
      _description.isNotEmpty ||
      _category != _defaultCategory ||
      _startedAt != null ||
      _endedAt != null;

  void _showSummaryDialog() {
    showSummaryDialog(
      context,
      title: 'Experience berhasil ditambahkan!',
      accent: AppColors.green,
      items: [
        SummaryItem(Icons.work_outline, 'Nama Experience', _title),
        SummaryItem(
          Icons.category_outlined,
          'Kategori',
          _categories[_category] ?? _category,
        ),
        SummaryItem(
          Icons.notes_rounded,
          'Deskripsi',
          _description.isEmpty ? '-' : _description,
        ),
        SummaryItem(Icons.event_outlined, 'Mulai', _startedController.text),
        SummaryItem(
          Icons.event_available_outlined,
          'Selesai',
          _endedAt == null ? 'Masih berlangsung' : _endedController.text,
        ),
      ],
      onClose: _resetForm,
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Experience',
          style: AppTextStyles.logo.copyWith(letterSpacing: 1),
        ),
        titleSpacing: 0,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.green, width: 1.5),
        ),
      ),
      drawer: const LeftDrawer(current: DrawerDestination.addExperience),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Experience (wajib, maks. 255 karakter) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _inputDecoration(
                    "Nama Experience",
                    hint: "Contoh: Asisten Dosen PBP",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!.trim();
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama experience tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Nama experience maksimal 255 karakter.";
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
                  accent: AppColors.green,
                  options: _categories,
                  value: _category,
                  onChanged: (String newValue) {
                    setState(() {
                      _category = newValue;
                    });
                  },
                ),
              ),

              // === Deskripsi (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: _inputDecoration(
                    "Deskripsi (opsional)",
                    hint: "Ceritakan peran atau kegiatanmu",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!.trim();
                    });
                  },
                ),
              ),

              // === Tanggal Mulai (wajib, lewat date picker) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedController,
                  readOnly: true,
                  onTap: _pickStartedDate,
                  decoration: _inputDecoration(
                    "Tanggal Mulai",
                    hint: "Pilih tanggal",
                    suffixIcon: const Icon(Icons.calendar_today_rounded),
                  ),
                  validator: (String? value) {
                    if (_startedAt == null) {
                      return "Tanggal mulai wajib diisi!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Selesai ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedController,
                  readOnly: true,
                  onTap: _pickEndedDate,
                  decoration: _inputDecoration(
                    "Tanggal Selesai (opsional)",
                    hint: "Kosongkan jika masih berlangsung",
                    // Tombol X muncul hanya jika tanggal selesai sudah diisi.
                    suffixIcon: _endedAt == null
                        ? const Icon(Icons.calendar_today_rounded)
                        : IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            tooltip: 'Kosongkan tanggal selesai',
                            onPressed: _clearEndedDate,
                          ),
                  ),
                  validator: (String? value) {
                    final started = _startedAt;
                    final ended = _endedAt;
                    if (started != null &&
                        ended != null &&
                        ended.isBefore(started)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai.";
                    }
                    return null;
                  },
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
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onPressed: () {
                        // Dialog hanya muncul jika semua input lolos validasi.
                        if (_formKey.currentState!.validate()) {
                          _showSummaryDialog();
                        }
                      },
                      child: const Text(
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
