import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/model/food_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModels foodModels;
  const EditFoodMenu({Key? key, required this.foodModels}) : super(key: key);

  @override
  State<EditFoodMenu> createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  final formkey = GlobalKey<FormState>();
  FoodModels? _foodModels;
  String? namefood, pricefood, detailfood, pathImage;
  double? width, height;
  File? file;

  @override
  void initState() {
    super.initState();
    _foodModels = widget.foodModels;
    namefood = _foodModels!.namefood;
    pricefood = _foodModels!.price;
    detailfood = _foodModels!.detail;
    pathImage = _foodModels!.pathimage;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: uploadFoodData(),
      appBar: AppBar(
        title: Text('ເເກ້ໄຂຂໍ້ມູນອາຫານ'),
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyStyle().sizedBox(context),
              buildNameFood(),
              MyStyle().sizedBoxline(context),
              groupImage(),
              MyStyle().sizedBoxline(context),
              buildPriceFood(),
              MyStyle().sizedBoxline(context),
              buildDetailFood(),
            ],
          ),
        ),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: const Icon(
            Icons.add_a_photo,
            size: 40,
          ),
        ),
        Container(
          color: Colors.grey,
          width: width! * 0.50,
          height: height! * 0.25,
          child: file == null
              ? Image.network(
                  '${MyNgrok().domainName}${_foodModels!.pathimage}',
                  fit: BoxFit.cover,
                )
              : Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: const Icon(
            Icons.add_photo_alternate,
            size: 40,
          ),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var files = await ImagePicker()
          .getImage(source: source, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(files!.path);
      });
    } catch (e) {}
  }

  Row uploadFoodData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            if (formkey.currentState!.validate()) {
              formkey.currentState!.save();
              confirmEdit();
            }
          },
          child: const Icon(Icons.upload),
        ),
      ],
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ທ່ານຕ້ອງການຈະເເກ້ໄຂຂໍ້ມູນນີ້ຈິງ ຫຼື ບໍ່ ?',
          style: MyStyle().primaryStyle(),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    editValueOnMysql();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                  label: Text(
                    'ຕ້ອງການ',
                    style: MyStyle().lightStyle(),
                  )),
              TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                  label: Text(
                    'ບໍ່ຕ້ອງການ',
                    style: MyStyle().lightStyle(),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMysql() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? id = preferences.getString('id');
    String? id = _foodModels!.id;
    String urleditvalue =
        '${MyNgrok().domainName}/fooddata/editFoodWhereId.php?isAdd=true&id=$id&namefood=$namefood&price=$pricefood&detail=$detailfood&pathimage=$pathImage';

    await Dio().get(urleditvalue).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().mydialog(context, 'ມີຂໍ້ມູນຜິດພາດ ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
      }
    });
  }

  Row buildDetailFood() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width! * 0.86,
          child: TextFormField(
            onChanged: (value) => detailfood = value.trim(),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            initialValue: detailfood,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.details),
              labelText: 'ລາຍລະອຽດອາຫານ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາປ້ອນຂໍ້ມູນດ້ວຍ';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildPriceFood() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width! * 0.86,
          child: TextFormField(
            onChanged: (value) => pricefood = value.trim(),
            keyboardType: TextInputType.number,
            initialValue: pricefood,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.attach_money),
              labelText: 'ລາຄາອາຫານ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາປ້ອນຂໍ້ມູນດ້ວຍ';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildNameFood() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width! * 0.86,
          child: TextFormField(
            onChanged: (value) => namefood = value.trim(),
            initialValue: namefood,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.add_alarm),
              labelText: 'ຊື່ອາຫານ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'ກະລຸນາປ້ອນຂໍ້ມູນດ້ວຍ';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
