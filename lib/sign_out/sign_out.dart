
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/authen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOut(BuildContext context) async{
  SharedPreferences preferences =await SharedPreferences.getInstance();
  preferences.clear();

  MaterialPageRoute route = MaterialPageRoute(builder: (context)=>Authen());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}