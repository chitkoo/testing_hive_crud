part of 'todo_bloc.dart';

enum LoadingStatus { unload, loading, succeed , failed}

class TodoState extends Equatable {
  const TodoState({
    this.todos = const [],
    this.loadingStatus = LoadingStatus.unload,
  });

  final List<Todo> todos;
  final LoadingStatus loadingStatus;

  @override
  List<Object> get props => [todos, loadingStatus];

  TodoState copyWith({
    List<Todo>? todos,
    LoadingStatus? loadingStatus,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
