import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dialog/my_dialog.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:flutter_app/widget/information_shop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInformation extends StatefulWidget {
  const AddInformation({Key? key}) : super(key: key);

  @override
  State<AddInformation> createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  final formkey = GlobalKey<FormState>();
  double? width, height, lat, lng;
  String? nameshop, addressshop, phoneshop, urlpicture;
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('Lat ===> $lat, Lng ===>$lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return findLocationData();
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildShopName(),
                  MyStyle().sizedBoxline(context),
                  buildShopAddress(),
                  MyStyle().sizedBoxline(context),
                  buildShopPhone(),
                  MyStyle().sizedBoxline(context),
                  buildShopImage(),
                  MyStyle().sizedBoxline(context),
                  lat == null ? MyStyle().showProgress() : buildShowMap(),
                  //buildShowMap(),
                  MyStyle().sizedBoxline(context),
                  buildSaveInfo(),
                  MyStyle().sizedBox(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('newmarker'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(title: 'ຮ້ານຢູ່ທີ່ນີ້', snippet: '$lat,$lng'),
      )
    ].toSet();
  }

  Container buildShowMap() {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: height! * 0.30,
      //color: Colors.amber,
      width: width,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {},
        markers: showMarker(),
      ),
    );
  }

  Container buildSaveInfo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      width: width! * 0.85,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          if (formkey.currentState!.validate()) {
            formkey.currentState!.save();
            if (file == null) {
              MyDialog().mydialog(context, 'ກະລຸນາໃສ່ຮູບຜ່ານກ່ອນ');
            } else {
              
              saveShopInfo();
            }
          }
        },
        child: Text(
          'ບັນທຶກຂໍ້ມູນ',
          style: MyStyle().lightStyle(),
        ),
      ),
    );
  }

  Future<Null> saveShopInfo() async {
    Random random = Random();
    int x = random.nextInt(1000000);
    String nameImage = 'shoppicture$x.jpg';
    String url = '${MyNgrok().domainName}/fooddata/imageshop.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData);
      urlpicture = '/fooddata/imageshop/$nameImage';
      print('urlpicture --->$urlpicture');
      editShopInfo();
    } catch (e) {
      print(e);
    }
  }
  Future<Null> editShopInfo() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    String url = '${MyNgrok().domainName}/fooddata/editUserWhereId.php?isAdd=true&id=$id&nameshop=$nameshop&addressshop=$addressshop&phoneshop=$phoneshop&urlpicture=$urlpicture&lat=$lat&lng=$lng';
    
    await Dio().get(url).then((value){
      if (value.toString() == 'true') {
        MaterialPageRoute route = MaterialPageRoute(builder: (context)=>InformationShop());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
       // Navigator.pop(context);
      } else {
        MyDialog().mydialog(context, 'ການບັນທຶກຂໍ້ມູນບໍ່ສຳເລັດ ກະລຸນາລົງໃໝ່ອີກຄັ້ງ');
      }
    });
  }

  Row buildShopImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () => chooseImage(ImageSource.camera),
            icon: Icon(
              Icons.photo_camera,
              size: 40,
            )),
        Container(
          width: width! * 0.60,
          height: height! * 0.25,
          color: Colors.amber,
          child: file == null
              ? Image.asset('images/gelley.png')
              : Image.file(file!),
        ),
        IconButton(
            onPressed: () => chooseImage(ImageSource.gallery),
            icon: Icon(
              Icons.photo_sharp,
              size: 40,
            ))
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final XFile? xFile = await imagePicker.pickImage(
          source: imageSource, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(xFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Container buildShopPhone() {
    return Container(
      width: width! * 0.85,
      child: TextFormField(
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
          if (value!.isEmpty || value == null) {
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
          if (value!.isEmpty || value == null) {
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
          if (value!.isEmpty || value == null) {
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
