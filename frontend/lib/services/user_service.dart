import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_repository.dart';

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<bool> login(String email, String password) async {
    final user = await _repository.login(email, password);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id);
      return true;
    }
    return false;
  }
}
