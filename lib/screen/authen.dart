import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/model/user_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/screen/createaccount.dart';
import 'package:flutter_app/screen/mainrider.dart';
import 'package:flutter_app/screen/mainshop.dart';
import 'package:flutter_app/screen/mainuser.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double? width, height;
  bool visibility = true;
  String? user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routeToMain();
  }

  Future<Null> routeToMain() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? chooseTypeUser = sharedPreferences.getString('typeuser');
      if (chooseTypeUser == 'user') {
        routeToService(MainUser());
      }else if(chooseTypeUser == 'shop'){
        routeToService(MainShop());
      }else if(chooseTypeUser =='rider'){
        routeToService(MainRider());
      }else{
       // MyDialog().mydialog(context, 'ປະເພດຂອງຜູ້ສະໝັກຜິດພາດ');
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget widget) async {
    MaterialPageRoute pageRoute =
        MaterialPageRoute(builder: (context) => widget);
    Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                  colors: [MyStyle().primaryColor, Colors.white],
                  radius: 1,
                  center:const Alignment(0, -1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().logoApp(context),
                // MyStyle().appName(),
                MyStyle().sizedBox(context),
                buildUser(),
                MyStyle().sizedBoxline(context),
                buildPassword(),
                MyStyle().sizedBox(context),
                buildLogin(),
                MyStyle().sizedBox(context),
                buildRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildRegister() {
    return Container(
      width: width! * 0.70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ບ່ອນລົງທະບຽນໃໝ່?',
            style: MyStyle().primaryStyle(),
          ),
          TextButton(
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) =>const CreateAccount());
              Navigator.push(context, route);
            },
            child: Text(
              'ລົງທະບຽນ',
              style: MyStyle().primaryStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildLogin() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      width: width! * 0.85,
      child: RaisedButton(
        padding:const EdgeInsets.only(top: 15, bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          if (user!.isEmpty ||
              user == null ||
              password!.isEmpty ||
              password == null) {
            MyDialog().mydialog(context, 'ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບ');
          } else {
            checkUserLogin();
          }
        },
        child: Text(
          'ເຂົ້າສູ່ລະບົບ',
          style: MyStyle().lightStyle(),
        ),
      ),
    );
  }

  Future<Null> checkUserLogin() async {
    String url =
        '${MyNgrok().domainName}/fooddata/getUserWhereUser.php?isAdd=true&user=$user';
    Response response = await Dio().get(url);
    // print("data is $response");
    try {
      var result = json.decode(response.data);
      for (var maps in result) {
        UserModel _userModel = UserModel.fromJson(maps);

        if (password == _userModel.password) {
          print('password ${password}');
          String? choosetypeuser = _userModel.typeuser;
          if (choosetypeuser == 'user') {
            toRouteService(MainUser(), _userModel);
          } else if (choosetypeuser == 'shop') {
            toRouteService(MainShop(), _userModel);
          } else if (choosetypeuser == 'rider') {
            toRouteService(MainRider(), _userModel);
          } else {
            MyDialog().mydialog(context, 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ ກະລຸນາປ້ອນໃໝ່');
          }
        } else {
          MyDialog().mydialog(context, 'ລະຫັດບໍ່ຖືກຕ້ອງ ກະລຸນາປ້ອນໃໝ່');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> toRouteService(Widget widget, UserModel userModels) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('id', userModels.id.toString());
    sharedPreferences.setString('name', userModels.name.toString());
    sharedPreferences.setString('typeuser', userModels.typeuser.toString());

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => widget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Container buildUser() {
    return Container(
      width: width! * 0.85,
      child: TextField(
        //controller: _usercontroller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            color: MyStyle().darkColor,
          ),
          labelText: 'ຊື່ຜູ້ໃຊ້',
          labelStyle: MyStyle().lightStyle(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple.shade600),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) {
          user = value.trim();
        },
      ),
    );
  }

  Container buildPassword() {
    return Container(
      width: width! * 0.85,
      child: TextField(
        // controller: _passwordcontroller,
        obscureText: visibility,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                visibility = !visibility;
              });
            },
            icon: Icon(
              visibility ? Icons.visibility_off : Icons.remove_red_eye,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: MyStyle().darkColor,
          ),
          labelText: 'ລະຫັດຜ່ານ',
          labelStyle: MyStyle().lightStyle(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple.shade600),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) {
          password = value.trim();
        },
      ),
    );
  }
}
