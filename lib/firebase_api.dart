import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class FirebaseApi {
  static String selectedKey = '';
  static final db = FirebaseDatabase.instance.ref('User');

  static Future<void> addUserData({required String userName}) async {
    String key = db.push().key!;
    await db.child(key).set(
      {
        'key': key,
        'userName': userName,
      },
    );
  }

  static Future<List<Map>> selectData() async {
    Map data =
        await db.once().then((value) => value.snapshot.value as Map? ?? {});
    List<Map> myUserList = [];
    data.forEach((key, value) {
      log("$value");
      myUserList.add(value);
    });
    return myUserList;
  }

  static Future<void> updateUserName(
      {required String key, required String userName}) async {
    await db.child(key).update({
      'key': key,
      'userName': userName,
    });
  }

  static Future<void> deleteUserData({required String key}) async {
    await db.child(key).remove();
  }
}
