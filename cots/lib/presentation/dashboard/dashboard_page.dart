import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../data/models/task_model.dart';
import '../../widgets/statistic_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/task_card.dart';
import '../task_list/task_list_page.dart';
import '../task_add/task_add_page.dart';
import '../task_detail/task_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = _generateInitialTasks();
  }

  List<Task> _generateInitialTasks() {
    return [
      Task(
        id: '1',
        judul: 'Perancangan MVC + Services',
        mataKuliah: 'Pemrograman Lanjut',
        deadline: DateTime(2026, 1, 18),
        catatan: '',
        status: TaskStatus.berjalan,
      ),
      Task(
        id: '2',
        judul: 'Integrasi API HoReCa Supply Chain',
        mataKuliah: 'Integrasi Sistem',
        deadline: DateTime(2026, 1, 20),
        catatan: '',
        status: TaskStatus.berjalan,
      ),
      Task(
        id: '3',
        judul: 'UI Mobile Slicing',
        mataKuliah: 'UI Engineering',
        deadline: DateTime(2026, 1, 17),
        catatan: '',
        status: TaskStatus.berjalan,
      ),
      Task(
        id: '4',
        judul: 'Dokumentasi Endpoint',
        mataKuliah: 'Pemrograman Lanjut',
        deadline: DateTime(2026, 1, 16),
        catatan: '',
        status: TaskStatus.berjalan,
      ),
      Task(
        id: '5',
        judul: 'Laporan Pengabdian',
        mataKuliah: 'KKN Tematik',
        deadline: DateTime(2026, 1, 12),
        catatan: '',
        status: TaskStatus.selesai,
      ),
    ];
  }

  int _getTaskStats(TaskStatus status) {
    return tasks.where((t) => t.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final selesaiTasks = _getTaskStats(TaskStatus.selesai);
    final upcomingTasks = [...tasks]
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    final nearestTasks = upcomingTasks.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tugas Besar',
                    style: AppTypography.heading1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final updatedTasks = await Navigator.push<List<Task>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskListPage(
                            tasks: tasks,
                            onTasksUpdated: (updatedList) {
                              setState(() => tasks = updatedList);
                            },
                          ),
                        ),
                      );
                      if (updatedTasks != null) {
                        setState(() => tasks = updatedTasks);
                      }
                    },
                    child: Text('Daftar Tugas'),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Statistics
              Row(
                children: [
                  Expanded(
                    child: StatisticCard(
                      label: 'Total Tugas',
                      value: totalTasks.toString(),
                      // icon: Icons.assignment,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatisticCard(
                      label: 'Selesai',
                      value: selesaiTasks.toString(),
                      // icon: Icons.check_circle,
                      // backgroundColor: AppColors.success.withOpacity(0.1),
                      // textColor: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Upcoming Tasks Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tugas Terdekat',
                    style: AppTypography.heading2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (nearestTasks.isEmpty)
                    Text(
                      'Belum ada tugas terjadwal',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (final task in nearestTasks)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: TaskCard(
                              task: task,
                              onTap: () async {
                                final updatedTask = await Navigator.push<Task>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailPage(task: task),
                                  ),
                                );

                                if (updatedTask != null) {
                                  setState(() {
                                    final index = tasks.indexWhere(
                                      (t) => t.id == task.id,
                                    );
                                    if (index != -1) {
                                      tasks[index] = updatedTask;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Action Buttons
              PrimaryButton(
                label: 'Tambah Tugas',
                onPressed: () async {
                  final newTask = await Navigator.push<Task>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskAddPage(),
                    ),
                  );
                  if (newTask != null) {
                    setState(() {
                      tasks.add(newTask);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   final months = [
  //     'Jan',
  //     'Feb',
  //     'Mar',
  //     'Apr',
  //     'May',
  //     'Jun',
  //     'Jul',
  //     'Aug',
  //     'Sep',
  //     'Oct',
  //     'Nov',
  //     'Dec',
  //   ];
  //   return '${date.day} ${months[date.month - 1]} ${date.year}';
  // }
}
