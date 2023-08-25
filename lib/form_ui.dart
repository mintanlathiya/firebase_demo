import 'dart:developer';

import 'package:firebase_demo/firebase_api.dart';
import 'package:flutter/material.dart';

class FireBaseDemo extends StatefulWidget {
  const FireBaseDemo({super.key});

  @override
  State<FireBaseDemo> createState() => _FireBaseDemoState();
}

class _FireBaseDemoState extends State<FireBaseDemo> {
  final TextEditingController _txtUserNameController = TextEditingController();
  late Future<List<Map>> futureUserData;
  bool isUpdate = false;

  @override
  void initState() {
    futureUserData = FirebaseApi.selectData();
    super.initState();
  }

  @override
  void dispose() {
    _txtUserNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: _txtUserNameController,
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: isUpdate
                  ? () async {
                      await FirebaseApi.updateUserName(
                        key: FirebaseApi.selectedKey,
                        userName: _txtUserNameController.text,
                      );
                      futureUserData = FirebaseApi.selectData();
                      _txtUserNameController.clear();
                      isUpdate = false;
                      setState(() {});
                    }
                  : () async {
                      await FirebaseApi.addUserData(
                        userName: _txtUserNameController.text,
                      );
                      futureUserData = FirebaseApi.selectData();

                      _txtUserNameController.clear();
                      setState(() {});
                    },
              color: Colors.blue,
              child: Text(isUpdate ? 'Update' : 'Submit'),
            ),
            FutureBuilder(
              future: futureUserData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          await FirebaseApi.deleteUserData(
                              key: snapshot.data![index]['key']);
                          futureUserData = FirebaseApi.selectData();
                          setState(() {});
                        },
                        child: ListTile(
                          onTap: () {
                            _txtUserNameController.text =
                                snapshot.data![index]['userName'];
                            FirebaseApi.selectedKey =
                                snapshot.data![index]['key'];
                            isUpdate = true;
                            log("${snapshot.data![index]['key']}");
                            setState(() {});
                          },
                          title: Text(
                            snapshot.data![index]['userName'],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
