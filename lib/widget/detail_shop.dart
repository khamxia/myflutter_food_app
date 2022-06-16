import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';

class DetailShop extends StatefulWidget {
  const DetailShop({Key? key}) : super(key: key);

  @override
  State<DetailShop> createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ລາຍການອາຫານທີ່ລູກຄ້າສັ່ງ'),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: MyStyle().titleCenter(context, 'ກຳລັງພັດທະນາຢູ່....'),
    );
  }
}
