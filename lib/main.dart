import 'package:flutter/material.dart';
import 'package:flutter_app/route.dart';

void main() {
  runApp(MyApp());
}

String initialRoute = '/authen';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.brown),
    );
  }
}
