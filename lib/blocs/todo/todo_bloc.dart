import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/repositories/local_storage/local_storage_repository.dart';

import '../../models/models.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required LocalStorageRepository localStorageRepository,
  })  : _localStorageRepository = localStorageRepository,
        super(const TodoState()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<DeleteAllTodos>(_onDeleteAllTodos);
  }

  final LocalStorageRepository _localStorageRepository;

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));
    try {
      Box box = await _localStorageRepository.openBox();
      List<Todo> todos = _localStorageRepository.getTodoList(box);
      emit(state.copyWith(
        loadingStatus: LoadingStatus.succeed,
        todos: todos,
      ));
    } catch (e) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failed));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state.loadingStatus == LoadingStatus.succeed) {
      try {
        Box box = await _localStorageRepository.openBox();
        _localStorageRepository.addTodo(box, event.todo);
        emit(
          state.copyWith(todos: _localStorageRepository.getTodoList(box)),
        );
      } catch (e) {
        emit(state.copyWith(loadingStatus: LoadingStatus.failed));
      }
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state.loadingStatus == LoadingStatus.succeed) {
      try {
        Box box = await _localStorageRepository.openBox();
        _localStorageRepository.updateTodo(box, event.todo);
        emit(
          state.copyWith(todos: _localStorageRepository.getTodoList(box)),
        );
      } catch (e) {
        emit(state.copyWith(loadingStatus: LoadingStatus.failed));
      }
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state.loadingStatus == LoadingStatus.succeed) {
      try {
        Box box = await _localStorageRepository.openBox();
        _localStorageRepository.deleteTodo(box, event.todo);
        emit(
          state.copyWith(todos: _localStorageRepository.getTodoList(box)),
        );
      } catch (e) {
        emit(state.copyWith(loadingStatus: LoadingStatus.failed));
      }
    }
  }

  void _onDeleteAllTodos(DeleteAllTodos event, Emitter<TodoState> emit) async {
    if (state.loadingStatus == LoadingStatus.succeed) {
      try {
        Box box = await _localStorageRepository.openBox();
       await _localStorageRepository.deleteAllTodos(box);
        debugPrint('DELETE :: ${_localStorageRepository.getTodoList(box)}');

        emit(
          state.copyWith(todos: _localStorageRepository.getTodoList(box)),
        );
      } catch (e) {
        emit(state.copyWith(loadingStatus: LoadingStatus.failed));
      }
    }
  }
}
