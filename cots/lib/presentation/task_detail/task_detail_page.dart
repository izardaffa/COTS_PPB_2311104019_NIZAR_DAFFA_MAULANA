import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../data/models/task_model.dart';
import '../../widgets/primary_button.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task _task;
  late TextEditingController _catatanController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _catatanController = TextEditingController(text: _task.catatan ?? '');
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    if (_task.isTerlambat) {
      return AppColors.danger;
    }
    switch (_task.status) {
      case TaskStatus.selesai:
        return AppColors.success;
      case TaskStatus.berjalan:
        return AppColors.primary;
      case TaskStatus.terlambat:
        return AppColors.danger;
    }
  }

  String _getStatusLabel() {
    if (_task.isTerlambat) {
      return 'Terlambat';
    }
    return _task.status.label;
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  void _toggleTaskStatus() {
    setState(() {
      if (_task.status == TaskStatus.selesai) {
        _task = _task.copyWith(status: TaskStatus.berjalan);
      } else {
        _task = _task.copyWith(status: TaskStatus.selesai);
      }
    });
  }

  void _saveCatatan() {
    setState(() {
      _task = _task.copyWith(catatan: _catatanController.text);
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Catatan berhasil disimpan'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusLabel = _getStatusLabel();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _task);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, _task),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          title: Text(
            'Detail Tugas',
            style: AppTypography.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    _saveCatatan();
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: AppSpacing.md),
                child: Center(
                  child: Text(
                    _isEditing ? 'Simpan' : 'Edit',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                _task.judul,
                style: AppTypography.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.bodyMedium.copyWith(color: statusColor),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Info Cards
              _buildInfoSection('Mata Kuliah', _task.mataKuliah),
              const SizedBox(height: AppSpacing.md),
              _buildInfoSection('Deadline', _formatDate(_task.deadline)),

              const SizedBox(height: AppSpacing.lg),

              // Status Toggle
              GestureDetector(
                onTap: _toggleTaskStatus,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
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
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _task.status == TaskStatus.selesai
                                ? AppColors.success
                                : AppColors.border,
                            width: 2,
                          ),
                          color: _task.status == TaskStatus.selesai
                              ? AppColors.success
                              : Colors.transparent,
                        ),
                        child: _task.status == TaskStatus.selesai
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Tugas sudah selesai',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_task.status == TaskStatus.selesai)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    'Centang jika tugas sudah final.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Catatan Section
              Text(
                'Catatan',
                style: AppTypography.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              if (_isEditing)
                TextField(
                  controller: _catatanController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Catatan tambahan (optional)',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    _task.catatan?.isNotEmpty == true
                        ? _task.catatan!
                        : 'Belum ada catatan',
                    style: AppTypography.body.copyWith(
                      color: _task.catatan?.isNotEmpty == true
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Delete Button
              PrimaryButton(
                label: 'Simpan Perubahan',
                onPressed: () {
                  Navigator.pop(context, _task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
