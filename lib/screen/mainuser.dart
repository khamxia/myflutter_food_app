import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';

class MainUser extends StatefulWidget {
  const MainUser({Key? key}) : super(key: key);

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  List<UserModel> userModel = <UserModel>[];
  List<Widget> shownewCard = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        '${MyNgrok().domainName}/fooddata/getUserWhereTypeser.php?isAdd=true&typeuser=shop';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        UserModel model = UserModel.fromJson(item);

        String? nameshops = model.nameshop;
        if (nameshops!.isNotEmpty) {
          print('data==${model.nameshop}');
          setState(() {
            userModel.add(model);
          shownewCard.add(createCard(model));
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel) {
    return Card(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            child:
                Image.network('${MyNgrok().domainName}${userModel.urlpicture}'),
          ),
          Text('${userModel.nameshop}'),
        ],
      ),
    );
  }

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
      body: GridView.extent(
        maxCrossAxisExtent: 150,
        children: shownewCard,
      ),
    );
  }
}
