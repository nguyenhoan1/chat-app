import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/users/user_model.dart';


class UserRepository {
  final _userRef = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _userRef.doc(user.uid).set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _userRef.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }
}
