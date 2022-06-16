import 'package:flutter/material.dart';
import 'package:flutter_app/style/mystyle.dart';

class MyDialog {
  Future<Null> mydialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('images/technical.png'),
          title: Text(title),
        ),
        clipBehavior: Clip.antiAlias,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ຕົກລົງ',
                    style: MyStyle().lightStyle(),
                  )),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
