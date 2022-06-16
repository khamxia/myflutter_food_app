import 'package:flutter/material.dart';

class MyStyle {
  MyStyle();
  Color darkColor = const Color(0xFF008fcc);
  Color primaryColor = const Color(0xFF1fbfff);
  Color lightColor1 = const Color(0xFF71f2ff);
  Color lightColor = const Color(0xFF4e8aa6);

  SizedBox sizedBox(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5 /5,
      );
  SizedBox sizedBoxline(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1 / 6,
      );

  TextStyle darkStyle() {
    return TextStyle(
      color: darkColor,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    );
  }

  TextStyle primaryStyle() {
    return TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 17,
    );
  }

  TextStyle lightStyle() {
    return TextStyle(
      color: lightColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
  }

  Widget logoApp(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.30,
      //color: Colors.amber,
      child: Image.asset('images/takeaway.png'),
    );
  }

  Widget appName() {
    return Container(
      child: Text('ເເອບຂາຍເຄື່ອງ', style: darkStyle()),
    );
  }
  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(
        color: MyStyle().darkColor,
      ),
    );
  }
  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: MediaQuery.of(context).size.width*0.70,
            child: SizedBox(
             // width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                string,
                style: MyStyle().primaryStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
