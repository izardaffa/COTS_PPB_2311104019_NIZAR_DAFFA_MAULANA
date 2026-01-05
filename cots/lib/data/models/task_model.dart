enum TaskStatus {
  berjalan('Berjalan'),
  selesai('Selesai'),
  terlambat('Terlambat');

  final String label;
  const TaskStatus(this.label);
}

class Task {
  final int id;
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
    int? id,
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

  factory Task.fromJson(Map<String, dynamic> json) {
    final statusString = (json['status'] as String?)?.toUpperCase();
    final isDone = json['is_done'] as bool? ?? false;
    final status = switch (statusString) {
      'SELESAI' => TaskStatus.selesai,
      'TERLAMBAT' => TaskStatus.terlambat,
      'BERJALAN' => TaskStatus.berjalan,
      _ => isDone ? TaskStatus.selesai : TaskStatus.berjalan,
    };

    return Task(
      id: json['id'] as int,
      judul: json['title'] as String,
      mataKuliah: json['course'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      catatan: json['note'] as String?,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': judul,
      'course': mataKuliah,
      'deadline': deadline.toIso8601String(),
      'status': switch (status) {
        TaskStatus.selesai => 'SELESAI',
        TaskStatus.terlambat => 'TERLAMBAT',
        TaskStatus.berjalan => 'BERJALAN',
      },
      'note': catatan,
      'is_done': status == TaskStatus.selesai,
    };
  }
}
