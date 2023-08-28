import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'to_do_model.g.dart';

@HiveType(typeId: 0)
class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.task,
    required this.isDone,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String task;
  @HiveField(2)
  final bool isDone;

  @override
  List<Object?> get props => [id, task, isDone];

  Todo copyWith({
    String? id,
    String? task,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
    );
  }
}
