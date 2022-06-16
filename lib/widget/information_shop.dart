import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/user_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:flutter_app/widget/add_information.dart';
import 'package:flutter_app/widget/edit_information.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  const InformationShop({Key? key}) : super(key: key);

  @override
  State<InformationShop> createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel? userModel;
  double? width, height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromUser();
  }

  Future<Null> readDataFromUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    String url =
        '${MyNgrok().domainName}/fooddata/getidWhereid.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) async {
      var result = json.decode(value.data);
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
          print('data ---->${userModel!.name}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມູນຂອງຮ້ານອາຫານ', style: MyStyle().darkStyle()),
        actions: [
          IconButton(
              onPressed: () => signOut(context),
              icon: Icon(
                Icons.exit_to_app,
                color: MyStyle().darkColor,
              )),
        ],
      ),
      body: Stack(
        children: [
          userModel == null
              ? MyStyle().showProgress()
              : userModel!.nameshop!.isEmpty
                  ? buildShowNoData(context)
                  : buildShowListInformation(),
          buildAddInformation(context),
        ],
      ),
    );
  }

  Widget buildShowListInformation() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'ລາຍລະອຽດຂອງຮ້ານ: ${userModel!.name}',
                  style: MyStyle().primaryStyle(),
                ),
              ),
              MyStyle().sizedBoxline(context),
              Text('ຊື່ຮ້ານອາຫານ : ${userModel!.nameshop}',
                  style: MyStyle().lightStyle()),
              MyStyle().sizedBoxline(context),
              showImage(),
              MyStyle().sizedBoxline(context),
              Text(
                'ສະຖານທີ່ຢູ່ຮ້ານ : ${userModel!.addressshop}',
                style: MyStyle().lightStyle(),
              ),
              MyStyle().sizedBoxline(context),
              Text(
                'ເບີໂທຕິດຕໍ່ຮ້ານ : ${userModel!.phoneshop}',
                style: MyStyle().lightStyle(),
              ),
              MyStyle().sizedBoxline(context),
              showMap()
            ],
          ),
        ],
      ),
    );
  }

  Container showMap() {
    double lat = double.parse(userModel!.lat.toString());
    double lng = double.parse(userModel!.lng.toString());

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16);
    return Container(
      color: Colors.amber,
      width: width! * 0.80,
      height: height! * 0.40,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.hybrid,
        onMapCreated: (controller) {},
        markers: markers(),
      ),
    );
  }

  Set<Marker> markers() {
    return <Marker>[
      Marker(
          markerId: MarkerId('12345'),
          position: LatLng(double.parse(userModel!.lat.toString()),
              double.parse(userModel!.lng.toString())),
          infoWindow: InfoWindow(
              title: 'ຮ້ານຢູ່ທີ່ນີ້',
              snippet: '${userModel!.lat},${userModel!.lng}'))
    ].toSet();
  }

  Column showImage() {
    return Column(
      children: [
        Text(
          'ຮູບພາບ',
          style: MyStyle().darkStyle(),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300),
          width: width! * 0.50,
          height: height! * 0.20,
          child: userModel == null
              ? MyStyle().showProgress()
              : userModel!.urlpicture!.isEmpty
                  ? Text(
                      'ກຳລັງໂຫລດຮູບພາບ...',
                      style: MyStyle().lightStyle(),
                    )
                  : Image.network(
                      '${MyNgrok().domainName}${userModel!.urlpicture}',fit: BoxFit.cover,),
        ),
      ],
    );
  }

  Widget buildShowNoData(BuildContext context) =>
      MyStyle().titleCenter(context, 'ຍັງບໍ່ມີຂໍ້ມູນ ກະລຸນາເພີ່ມຂໍ້ມູນ');

  Column buildAddInformation(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, right: 10),
              child: FloatingActionButton(
                onPressed: () {
                  routeToAddInfo();
                },
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeToAddInfo() {
    Widget widget =
        userModel!.addressshop!.isEmpty ? AddInformation() : EditInformation();
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => widget);
    Navigator.push(context, route).then(
      (value) => readDataFromUser(),
    );
  }
}
