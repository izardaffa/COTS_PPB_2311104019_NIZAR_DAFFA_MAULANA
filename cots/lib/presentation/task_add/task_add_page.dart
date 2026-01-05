import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../data/models/task_model.dart';
import '../../widgets/task_input.dart';
import '../../widgets/primary_button.dart';

class TaskAddPage extends StatefulWidget {
  const TaskAddPage({super.key});

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _mataKuliahController = TextEditingController();
  final _catatanController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _judulController.dispose();
    _mataKuliahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  String? _validateJudul(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tugas tidak boleh kosong';
    }
    if (value.length < 5) {
      return 'Judul minimal 5 karakter';
    }
    return null;
  }

  String? _validateMataKuliah(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mata kuliah tidak boleh kosong';
    }
    return null;
  }

  String? _validateDeadline() {
    if (_selectedDate == null) {
      return 'Deadline harus dipilih';
    }
    if (_selectedDate!.isBefore(DateTime.now())) {
      return 'Deadline harus minimal hari ini';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _validateDeadline() == null) {
      final newTask = Task(
        id: DateTime.now().toString(),
        judul: _judulController.text,
        mataKuliah: _mataKuliahController.text,
        deadline: _selectedDate!,
        catatan: _catatanController.text.isNotEmpty
            ? _catatanController.text
            : null,
        status: TaskStatus.berjalan,
      );

      Navigator.pop(context, newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newTask.judul} berhasil ditambahkan'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field yang diperlukan'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          title: Text(
            'Tambah Tugas',
            style: AppTypography.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Input
                TaskInput(
                  label: 'Judul Tugas',
                  hint: 'Masukkan judul tugas',
                  controller: _judulController,
                  validator: _validateJudul,
                  prefixIcon: const Icon(
                    Icons.assignment,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Mata Kuliah Input
                TaskInput(
                  label: 'Mata Kuliah',
                  hint: 'Pilih mata kuliah',
                  controller: _mataKuliahController,
                  validator: _validateMataKuliah,
                  prefixIcon: const Icon(
                    Icons.school,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Deadline Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deadline',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedDate == null
                                ? AppColors.border
                                : AppColors.primary,
                            width: _selectedDate == null ? 1 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              _selectedDate == null
                                  ? 'Pilih tanggal'
                                  : DateFormat(
                                      'd MMMM yyyy',
                                      'id_ID',
                                    ).format(_selectedDate!),
                              style: AppTypography.body.copyWith(
                                color: _selectedDate == null
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_validateDeadline() != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          _validateDeadline()!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Catatan Input
                TaskInput(
                  label: 'Catatan',
                  hint: 'Catatan tambahan (optional)',
                  controller: _catatanController,
                  maxLines: 4,
                  prefixIcon: const Icon(
                    Icons.note,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Submit Button
                Column(
                  children: [
                    PrimaryButton(
                      label: 'Tambah Tugas',
                      onPressed: _submitForm,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
