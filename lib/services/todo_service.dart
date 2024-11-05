// lib/services/todo_service.dart

import '../models/todo_model.dart';

class TodoService {
  final List<Todo> _todos = [];

  List<Todo> getTodos() {
    return _todos;
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
  }

  void editTodo(int index, Todo todo) {
    if (index >= 0 && index < _todos.length) {
      _todos[index] = todo;
    }
  }

  void deleteTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
    }
  }
}
