import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_test/models/models.dart';

import '../../blocs/todo/todo_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('To Do List'),
            actions: [
              state.todos.length >= 2
                  ? IconButton(
                      onPressed: () =>
                          context.read<TodoBloc>().add(DeleteAllTodos()),
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      tooltip: 'Remove All',
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          backgroundColor: Colors.grey.shade100,
          body: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.loadingStatus == LoadingStatus.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              if (state.loadingStatus == LoadingStatus.failed) {
                return const Center(
                  child: Text('Unale to load todos'),
                );
              }

              if (state.loadingStatus == LoadingStatus.succeed &&
                  state.todos.isEmpty) {
                return const Center(
                  child: Text('Add to do list'),
                );
              }

              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  Todo todo = state.todos[index];

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('ID : ${todo.id} => '),
                        Expanded(child: Text(todo.task)),
                        IconButton(
                            onPressed: () {
                              _showModalBottomSheet(
                                  context: context, todo: todo);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                          onPressed: () {
                            context
                                .read<TodoBloc>()
                                .add(DeleteTodo(todo: todo));
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showModalBottomSheet(context: context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showModalBottomSheet({
    required BuildContext context,
    Todo? todo,
  }) async {
    TextEditingController idController = TextEditingController();
    TextEditingController taskController = TextEditingController();

    if (todo != null) {
      idController.text = todo.id;
      taskController.text = todo.task;
    }

    showModalBottomSheet(
      isDismissible: true,
      elevation: 5,
      barrierColor: Colors.black.withAlpha(50),
      context: context,
      builder: (builder) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'ID'),
            ),
            TextFormField(
              controller: taskController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(hintText: 'Task'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (todo != null) {
                  context.read<TodoBloc>().add(
                        UpdateTodo(
                          todo: todo.copyWith(
                              id: idController.text, task: taskController.text),
                        ),
                      );
                } else {
                  Todo todo = Todo(
                    id: idController.text,
                    task: taskController.text,
                    isDone: false,
                  );

                  context.read<TodoBloc>().add(AddTodo(todo: todo));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
