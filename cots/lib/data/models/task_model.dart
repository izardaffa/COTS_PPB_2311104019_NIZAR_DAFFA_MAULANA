enum TaskStatus {
  berjalan('Berjalan'),
  selesai('Selesai'),
  terlambat('Terlambat');

  final String label;
  const TaskStatus(this.label);
}

class Task {
  final String id;
  final String judul;
  final String mataKuliah;
  final DateTime deadline;
  final String? catatan;
  TaskStatus status;

  Task({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.deadline,
    this.catatan,
    this.status = TaskStatus.berjalan,
  });

  bool get isTerlambat {
    return status != TaskStatus.selesai && DateTime.now().isAfter(deadline);
  }

  Task copyWith({
    String? id,
    String? judul,
    String? mataKuliah,
    DateTime? deadline,
    String? catatan,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      deadline: deadline ?? this.deadline,
      catatan: catatan ?? this.catatan,
      status: status ?? this.status,
    );
  }
}
