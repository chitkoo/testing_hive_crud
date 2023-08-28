import 'package:hive/hive.dart';
import 'package:hive_test/models/models.dart';

abstract class BaseLocalStorageRepository {
  Future<Box> openBox();
  List<Todo> getTodoList(Box box);
  Future<void> addTodo(Box box, Todo todo);
  Future<void> updateTodo(Box box, Todo todo);
  Future<void> deleteTodo(Box box, Todo todo);
  Future<void> deleteAllTodos(Box box);
}
