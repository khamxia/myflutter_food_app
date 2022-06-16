import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/model/user_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInformation extends StatefulWidget {
  const EditInformation({Key? key}) : super(key: key);

  @override
  State<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  final formkey = GlobalKey<FormState>();
  UserModel? userModel;
  double? width, height, lat, lng;
  String? nameshop, phoneshop, addressshop, urlpicture;
  File? file;

  Location location = Location();
  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      lat = event.latitude;
      lng = event.longitude;

      // print('lat ==$lat,lng ==$lng');
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString('id');
    String url =
        '${MyNgrok().domainName}/fooddata/getidWhereid.php?isAdd=true&id=$id';

    try {
      await Dio().get(url).then((value) {
        var result = json.decode(value.data);
        for (var maps in result) {
          setState(() {
            userModel = UserModel.fromJson(maps);
            nameshop = userModel!.nameshop;
            addressshop = userModel!.addressshop;
            phoneshop = userModel!.phoneshop;
            urlpicture = userModel!.urlpicture;
          });
        }
      });
    } catch (e) {
    print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'ປັບປຸງຮ້ານອາຫານ',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () => signOut(context),
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SingleChildScrollView(
            child:
                userModel == null ? MyStyle().showProgress() : showContant()));
  }

  Widget showContant() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildShopName(),
              MyStyle().sizedBoxline(context),
              buildShopAddress(),
              MyStyle().sizedBoxline(context),
              buildShopPhone(),
              MyStyle().sizedBoxline(context),
              showImages(),
              MyStyle().sizedBoxline(context),
              lat == null ? MyStyle().showProgress() : showMap(),
              MyStyle().sizedBoxline(context),
              editButton(),
              MyStyle().sizedBox(context),
            ],
          ),
        ),
      ],
    );
  }

  Container editButton() {
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
          confirmDialog();
        },
        child: Text(
          'ກົດເພື່ອເເກ້ໄຂ້ຂໍ້ມູນ',
          style: MyStyle().lightStyle(),
        ),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: ListTile(
          leading: Image.asset('images/gelley.png'),
          title: Text(
            'ທ່ານແນ່ໃຈແລ້ວບໍທີ່ທ່ານຈະເເກ້ໄຂຂໍ້ມູນນີ້',
            style: MyStyle().lightStyle(),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, '/informationshop', (route) => false);

                  if (formkey.currentState!.validate()) {
                    formkey.currentState!.save();
                    if (nameshop!.isEmpty ||
                        addressshop!.isEmpty ||
                        phoneshop!.isEmpty) {
                      MyDialog()
                          .mydialog(context, 'ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບກ່ອນ');
                    }else if(file == null){
                      MyDialog().mydialog(context, 'ກະລຸນາເລືອກຮູບພາບ');
                    }else{
                      Navigator.pop(context);
                      editInfo();
                    }
                  }
                },
                child: Text(
                  'ຕົກລົງ',
                  style: MyStyle().primaryStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ຍົກເລີກ',
                  style: MyStyle().primaryStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> editInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString('id');
    Random random = Random();
    int i = random.nextInt(100000);
    String namefile = 'editimageshop$i';

    String urlUpload = '${MyNgrok().domainName}/fooddata/imageshop.php';
    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: namefile);

    FormData formData = FormData.fromMap(map);
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlpicture = '/fooddata/imageshop/$namefile';
      print('urlpicture ==$urlpicture');
      String url =
          '${MyNgrok().domainName}/fooddata/editUserWhereId.php?isAdd=true&id=$id&nameshop=$nameshop&addressshop=$addressshop&phoneshop=$phoneshop&urlpicture=$urlpicture&lat=$lat&lng=$lng';
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        // Navigator.pop(context);
        Navigator.pop(context);
      } else {
        MyDialog()
            .mydialog(context, 'ການອັບເດັດຂໍ້ມູນບໍ່ສຳເລັດ ກະລຸນາລອງໃໝ່ອີກຄັ້ງ');
      }
    });
    
  }

  Widget showMap() {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16);
    return Container(
      width: width! * 0.90,
      height: height! * 0.30,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {},
        markers: showMarker(),
      ),
    );
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('112233'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(title: 'ຮ້ານຢູ່ທີ່ນີ້', snippet: '$lat,$lng'),
      )
    ].toSet();
  }

  Widget showImages() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => chooseImage(ImageSource.camera),
              icon:const Icon(Icons.add_a_photo, size: 40),
            ),
            Container(
                color: Colors.grey.shade300,
                width: width! * 0.60,
                height: height! * 0.30,
                child: file == null
                    ? Image.network(
                        '${MyNgrok().domainName}${urlpicture}',
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.cover,
                      )),
            IconButton(
              onPressed: () => chooseImage(ImageSource.gallery),
              icon:const Icon(Icons.photo, size: 40),
            ),
          ],
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    final xFile =
        await picker.getImage(source: source, maxHeight: 800, maxWidth: 800);
    setState(() {
      file = File(xFile!.path);
    });
  }

  Container buildShopPhone() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
        onChanged: (value) => phoneshop = value.trim(),
        initialValue: phoneshop,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'ເບີໂທລະສັບ',
          labelStyle: MyStyle().lightStyle(),
          prefixIcon: Icon(
            Icons.phone,
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
          if (value!.isEmpty) {
            return 'ກະລຸນາປ້ອນເບີໂທລະສັບ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          phoneshop = save!.trim();
        },
      ),
    );
  }

  Container buildShopAddress() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
        onChanged: (value) => addressshop = value.trim(),
        initialValue: addressshop,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'ທີ່ຢູ່ຮ້ານອາຫານ',
          labelStyle: MyStyle().lightStyle(),
          prefixIcon: Icon(
            Icons.home,
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
          if (value!.isEmpty) {
            return 'ກະລຸນາທີ່ຢູ່ຂອງຮ້ານ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          addressshop = save!.trim();
        },
      ),
    );
  }

  Container buildShopName() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: width! * 0.85,
      child: TextFormField(
        onChanged: (value) => nameshop = value.trim(),
        initialValue: nameshop,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'ຊື່ຮ້ານອາຫານ',
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
          if (value!.isEmpty) {
            return 'ກະລຸນາປ້ອນຊື່ ແລະ ນາມສະກຸນ';
          } else {
            return null;
          }
        },
        onSaved: (String? save) {
          nameshop = save!.trim();
        },
      ),
    );
  }
}
