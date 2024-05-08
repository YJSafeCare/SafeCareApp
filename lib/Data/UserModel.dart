import 'package:flutter/foundation.dart';

import 'User.dart';

class UserModel extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  UserModel({User? user}) : _currentUser = user;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}