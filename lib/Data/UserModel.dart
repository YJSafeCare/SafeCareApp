import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'User.dart';

class UserModel extends StateNotifier<String> {
  final Ref ref;
  String _userToken = '';

  UserModel(this.ref) : super('');

  Future<void> login(String username) async {
    state = username;
  }

  // Get username
  String get username => state;
  set username(String username) {
    state = username;
  }

  // Get user token
  String get userToken => _userToken;
  set userToken(String token) {
    _userToken = token;
  }

}

final userModelProvider = StateNotifierProvider<UserModel, String>((ref) {
  return UserModel(ref);
});