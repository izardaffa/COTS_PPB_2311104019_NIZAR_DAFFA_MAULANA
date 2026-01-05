import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../data/models/task_model.dart';
import '../../widgets/task_card.dart';
import '../task_detail/task_detail_page.dart';
import '../task_add/task_add_page.dart';

class TaskListPage extends StatefulWidget {
  final List<Task> tasks;
  final Function(List<Task>)? onTasksUpdated;

  const TaskListPage({super.key, required this.tasks, this.onTasksUpdated});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<Task> _tasks;
  TaskStatus? _selectedFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  List<Task> _getFilteredTasks() {
    var filtered = _tasks;

    // Filter by status
    if (_selectedFilter != null) {
      filtered = filtered.where((task) {
        if (_selectedFilter == TaskStatus.terlambat) {
          return task.isTerlambat;
        }
        return task.status == _selectedFilter;
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (task) =>
                task.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                task.mataKuliah.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _tasks);
        widget.onTasksUpdated?.call(_tasks);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, _tasks);
              widget.onTasksUpdated?.call(_tasks);
            },
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          centerTitle: true,
          title: Text(
            'Daftar Tugas',
            style: AppTypography.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newTask = await Navigator.push<Task>(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskAddPage()),
                );
                if (newTask != null) {
                  setState(() {
                    _tasks.add(newTask);
                  });
                }
              },
              child: Text('Tambah'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari tugas atau mata kuliah...',
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
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
              ),

              const SizedBox(height: AppSpacing.md),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', null),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip('Berjalan', TaskStatus.berjalan),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip('Selesai', TaskStatus.selesai),
                    const SizedBox(width: AppSpacing.sm),
                    _buildFilterChip('Terlambat', TaskStatus.terlambat),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Tasks List
              if (filteredTasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_turned_in,
                          size: 48,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Tidak ada tugas',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: filteredTasks.map((task) {
                    return TaskCard(
                      task: task,
                      onTap: () async {
                        final updatedTask = await Navigator.push<Task>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(task: task),
                          ),
                        );
                        if (updatedTask != null) {
                          setState(() {
                            final index = _tasks.indexWhere(
                              (t) => t.id == task.id,
                            );
                            if (index != -1) {
                              _tasks[index] = updatedTask;
                            }
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, TaskStatus? status) {
    final isSelected = _selectedFilter == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? null : status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
