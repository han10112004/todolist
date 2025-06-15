
import 'package:todolist/models/todo_item_model.dart';
import 'package:todolist/repositories/todo_repository.dart';

class TodoService {
  final TodoRepository _repository;

  TodoService (this._repository);

  Future<Map<String, dynamic>> create(String title, String decription, int statusId, int userId, String startTime,
    String endTime,) {
    return _repository.create(title, decription, statusId, userId, startTime, endTime);
  }

  Future<List<TodoItemModel>> getAll() async {
    return await _repository.getAll();
  }

  Future<Map<String, String>> update(int id, String title, String decription, int statusId, int userId) {
    return _repository.update(id, title, decription, statusId, userId);
  }

  Future<void> delete(int id) {
    return _repository.delete(id);
  }

  Future<void> deleteMany(List<int> ids) {
    return _repository.deleteMany(ids);
  }
}