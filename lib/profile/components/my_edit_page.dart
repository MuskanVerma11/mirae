import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mirae/login/auth_page.dart';
import 'package:mirae/login/firebase_provider.dart';
import 'package:mirae/profile/components/edit_user_image.dart';
import 'package:mirae/profile/components/edit_user_info.dart';
import 'package:mirae/profile/components/edit_user_name.dart';
import 'package:mirae/profile/components/level_rank.dart';
import 'package:provider/provider.dart';

class MyEditPage extends StatefulWidget {
  @override
  _MyEditPageState createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Color(0xffF5F4F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 0.28 * height,
            child: Stack(children: [
              LevelRankWidget(),
              Positioned(
                  left: width * 0.368,
                  top: 0.165 * height,
                  child: EditImageNameWidget()),
              Positioned(
                left: width * 0.360,
                top: 0.215 * height,
                child: EditUserName(),
              )
            ]),
          ),
          SizedBox(
            height: 0.06 * height,
          ),
          EditUserInfo(),
          SizedBox(
            height: 0.05 * height,
          ),
          TextButton(
              onPressed: () {
                fp.signOut();
                Get.offAll(AuthPage());
              },
              child: Text("LOG OUT",
                  style: TextStyle(
                      color: Color(0xffFF4646),
                      fontFamily: "GoogleSans",
                      fontSize: 18,
                      fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }
}
