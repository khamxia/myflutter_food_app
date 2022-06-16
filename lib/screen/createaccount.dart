import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/screen/authen.dart';
import 'package:flutter_app/style/mystyle.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formkeys = GlobalKey<FormState>();
  double? width, height;
  bool visibility = true;
  String? typeuser, user, password, name, email;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ບ່ອນລົງທະບຽນ',
          style: MyStyle().darkStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formkeys,
                    child: Column(
                      children: [
                        buildTile('ຂໍ້ມູນທົ່ວໄປ:'),
                        MyStyle().sizedBoxline(context),
                        buildName(),
                        MyStyle().sizedBoxline(context),
                        buildEmail(),
                        MyStyle().sizedBoxline(context),
                        buildUser(),
                        MyStyle().sizedBoxline(context),
                        buildPassword(),
                        MyStyle().sizedBoxline(context),
                        buildTile('ປະເພດຂອງຜູ້ສະໝັກ:'),
                        MyStyle().sizedBoxline(context),
                        buildRadioUser(),
                        MyStyle().sizedBoxline(context),
                        buildRadioShop(),
                        MyStyle().sizedBoxline(context),
                        buildRadioRider(),
                        MyStyle().sizedBoxline(context),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: width! * 0.85,
                            child: RaisedButton(
                              color: Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () {
                                // Navigator.pushNamedAndRemoveUntil(
                                //     context, '/mainshop', (route) => false);
                                if (formkeys.currentState!.validate()) {
                                  formkeys.currentState!.save();
                                 if(typeuser == null || typeuser!.isEmpty){
                                   MyDialog().mydialog(context, 'ກະລຸນາເລືອກປະເພດຂອງຜູ້ໃຊ້');
                                 }else{
                                   checkUser();
                                 }

                                }
                              },
                              child: const Text('ບັນທຶກຂໍ້ມູນ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<Null> checkUser() async{
    String url = '${MyNgrok().domainName}/fooddata/getUserWhereUser.php?isAdd=true&user=$user';

    Response response = await Dio().get(url);
    if(response.toString() =='null'){
      reigster();
    }else{
      MyDialog().mydialog(context, '$user ຊື່ຜູ້ໃຊ້ນີ້ມີຄົນໃຊ້ແລ້ວ ກະລຸນາປ້ອນຊື່ໃໝ່');
    }
  }

  Future<Null> reigster() async {
    String url =
        '${MyNgrok().domainName}/fooddata/insertData.php?isAdd=true&name=$name&email=$email&user=$user&password=$password&typeuser=$typeuser';
    Response response = await Dio().post(url);

    if (response.toString() == 'true') {
      MaterialPageRoute route =
          MaterialPageRoute(builder: (context) => Authen());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      MyDialog().mydialog(context, 'ຂໍ້ມູນເກີດຄວາມຜິດຜາດ ກະລຸນາປ້ອນຂໍ້ມູນໃໝ່');
    }
  }

  Container buildRadioRider() {
    return Container(
      width: width! * 0.80,
      child: RadioListTile(
          title: Text(
            'ຜູ້ສົ່ງອາຫານ',
            style: MyStyle().lightStyle(),
          ),
          value: 'rider',
          groupValue: typeuser,
          onChanged: (value) {
            setState(() {
              typeuser = value as String;
            });
          }),
    );
  }

  Container buildRadioShop() {
    return Container(
      width: width! * 0.80,
      child: RadioListTile(
          title: Text(
            'ເຈົ້າຂອງຮ້ານ',
            style: MyStyle().lightStyle(),
          ),
          value: 'shop',
          groupValue: typeuser,
          onChanged: (value) {
            setState(() {
              typeuser = value as String;
            });
          }),
    );
  }

  Container buildRadioUser() {
    return Container(
      width: width! * 0.80,
      child: RadioListTile(
          title: Text(
            'ຜູ້ສັ່ງອາຫານ',
            style: MyStyle().lightStyle(),
          ),
          value: 'user',
          groupValue: typeuser,
          onChanged: (value) {
            setState(() {
              typeuser = value as String;
            });
          }),
    );
  }

  Container buildPassword() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
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
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty || value == null || value.length < 8) {
            return 'ກະລຸນາປ້ອນລະຫັດຜ່ານຢ່າງໜ້ອຍ 8 ຕົວ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          password = save!.trim();
        },
      ),
    );
  }

  Container buildUser() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            color: MyStyle().darkColor,
          ),
          labelText: 'ຊື່ຜູ້ໃຊ້',
          labelStyle: MyStyle().lightStyle(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty || value == null) {
            return 'ກະລຸນາປ້ອນຊື່ຜູ້ໃຊ້';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          user = save!.trim();
        },
      ),
    );
  }

  Container buildEmail() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: MyStyle().darkColor,
          ),
          labelText: 'ອີເມວ',
          labelStyle: MyStyle().lightStyle(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (String? value) {
          if (!((value!.contains('@'))|| (value.contains('.')))) {
            return 'ອີເມວຂອງທ່ານຜິດ ກະລຸນາປ້ອນໃໝ່ອີກຄັ້ງ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          email = save!.trim();
        },
      ),
    );
  }

  Container buildName() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'ຊື່ ແລະ ນາມສະກຸນ',
          labelStyle: MyStyle().lightStyle(),
          prefixIcon: Icon(
            Icons.person,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty || value == null) {
            return 'ກະລຸນາປ້ອນຊື່ ແລະ ນາມສະກຸນ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          name = save!.trim();
        },
      ),
    );
  }

  Container buildTile(String string) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Text(
        string,
        style: MyStyle().primaryStyle(),
      ),
    );
  }
}
