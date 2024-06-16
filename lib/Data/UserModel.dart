import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Group.dart';
import 'User.dart';

class UserModel extends StateNotifier<String> {
  final Ref ref;
  String _userToken = '';
  String _userSerial = '';
  List<Group> _userGroups = [];

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

  // Get user serial
  String get userSerial => _userSerial;
  set userSerial(String serial) {
    _userSerial = serial;
  }

  // Get user groups
  List<Group> get userGroups => _userGroups;
  set userGroups(List<Group> groups) {
    _userGroups = groups;
  }

}

final userModelProvider = StateNotifierProvider<UserModel, String>((ref) {
  return UserModel(ref);
});