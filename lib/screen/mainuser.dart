import 'package:flutter/material.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';

class MainUser extends StatefulWidget {
  const MainUser({Key? key}) : super(key: key);

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: ()=>signOut(context), icon:const Icon(Icons.exit_to_app),),],),
      body: MyStyle().titleCenter(context, 'ກຳລັງພັດທະນາ'),
    );
  }
}
