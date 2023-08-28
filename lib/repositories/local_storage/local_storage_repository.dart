import 'package:hive/hive.dart';
import 'package:hive_test/models/to_do_model/to_do_model.dart';
import 'package:hive_test/repositories/local_storage/base_local_storage_repository.dart';

class LocalStorageRepository implements BaseLocalStorageRepository {
  String boxName = 'to_do';
  Type boxType = Todo;

  @override
  Future<Box> openBox() async {
    Box box = await Hive.openBox<Todo>(boxName);
    return box;
  }

  @override
  List<Todo> getTodoList(Box box) {
    return box.values.toList().cast<Todo>();
  }

  @override
  Future<void> addTodo(Box box, Todo todo) async {
    await box.put(todo.id, todo);
  }

  @override
  Future<void> updateTodo(Box box, Todo todo) async {
    await box.put(todo.id, todo);
  }

  @override
  Future<void> deleteTodo(Box box, Todo todo) async {
    await box.delete(todo.id);
  }

  @override
  Future<void> deleteAllTodos(Box box) async {
    await box.clear();
  }
}
