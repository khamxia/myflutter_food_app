import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  const AddFoodMenu({Key? key}) : super(key: key);

  @override
  State<AddFoodMenu> createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File? file;
  double? width, height;
  String? namefood, price, detail, urlImagefood;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ເພີ່ມລາຍການອາຫານ',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              showTitleTop('ຮູບພາບ:'),
              MyStyle().sizedBoxline(context),
              groupImage(),
              MyStyle().sizedBoxline(context),
              showTitleTop('ລາຍລະອຽດອາຫານ:'),
              MyStyle().sizedBoxline(context),
              namefoodform(),
              MyStyle().sizedBoxline(context),
              pricefoodform(),
              MyStyle().sizedBoxline(context),
              detailfoodform(),
              MyStyle().sizedBox(context),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: width! * 0.80,
      child: RaisedButton.icon(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          if (file == null) {
            MyDialog().mydialog(
                context, 'ກະລຸນາເລືອກຮູບພາບກ່ອນ ໂດຍການຖ່າຍ ຫຼື ເລືອກຈາກຄັງຮູບ');
          } else if (namefood!.isEmpty ||
              namefood == null ||
              price!.isEmpty ||
              price == null ||
              detail!.isEmpty ||
              detail == null) {
            MyDialog().mydialog(context, 'ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບກ່ອນ');
          } else {
            Navigator.pop(context);
            
            uploadFoodAndInsertData();
          }
        },
        icon: const Icon(Icons.save_as),
        label: const Text('Save Food Menu'),
      ),
    );
  }

  Future<Null> uploadFoodAndInsertData() async {
    String urlUpload = '${MyNgrok().domainName}/fooddata/savefood.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String namefile = 'food$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: namefile);

      FormData formData = FormData.fromMap(map);
      await Dio().post(urlUpload, data: formData).then((value) async {
        urlImagefood = '/fooddata/imagefood/$namefile';
        print('picture ==> $urlImagefood');
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String idshop = sharedPreferences.getString('id').toString();
        String urlinsertData =
            '${MyNgrok().domainName}/fooddata/addfood.php?isAdd=true&idshop=$idshop&namefood=$namefood&pathimage=$urlImagefood&price=$price&detail=$detail';
        await Dio().get(urlinsertData).then((value) {
          Navigator.pop(context);
        });
      });
    } catch (e) {}
  }

  Container detailfoodform() {
    return Container(
      width: width! * 0.85,
      child: TextField(
        onChanged: (value) => detail = value.trim(),
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            labelText: 'ລາຍລະອຽດອາຫານ',
            prefixIcon: const Icon(Icons.details),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }

  Container pricefoodform() {
    return Container(
      width: width! * 0.85,
      child: TextField(
        onChanged: (value) => price = value.trim(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'ລາຄາອາຫານ:',
            prefixIcon: const Icon(Icons.attach_money),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }

  Container namefoodform() {
    return Container(
      width: width! * 0.85,
      child: TextField(
        onChanged: (value) => namefood = value.trim(),
        decoration: InputDecoration(
            labelText: 'ຊື່ອາຫານ:',
            prefixIcon: Icon(Icons.fastfood),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: width! * 0.20,
          height: height! * 0.10,
          child: IconButton(
            onPressed: () => chooseImage(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 40,
            ),
          ),
        ),
        Container(
          color: Colors.amber,
          width: width! * 0.50,
          height: height! * 0.20,
          child: file == null
              ? Image.asset('images/addfoodmenu.png',fit: BoxFit.cover,)
              : Image.file(file!,fit: BoxFit.cover,),
        ),
        Container(
          width: width! * 0.20,
          height: height! * 0.10,
          child: IconButton(
            onPressed: () => chooseImage(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    var newfile = await ImagePicker()
        .getImage(source: source, maxHeight: 800, maxWidth: 800);
    setState(() {
      file = File(newfile!.path);
    });
  }

  Row showTitleTop(String titletop) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 13, top: 10),
          child: Text(
            titletop,
            style: MyStyle().primaryStyle(),
          ),
        ),
      ],
    );
  }
}
