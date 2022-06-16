import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';

class MainRider extends StatefulWidget {
  const MainRider({Key? key}) : super(key: key);

  @override
  State<MainRider> createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: MyStyle().titleCenter(context, 'ຍັງກຳລັງພັດທະນາ'),
    );
  }
}
