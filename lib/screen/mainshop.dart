import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/authen.dart';
import 'package:flutter_app/sign_out/sign_out.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:flutter_app/widget/detail_shop.dart';
import 'package:flutter_app/widget/information_shop.dart';
import 'package:flutter_app/widget/list_food_shop.dart';

class MainShop extends StatefulWidget {
  const MainShop({Key? key}) : super(key: key);

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  double? width, height;

  final List<String> _items = [
    'images/takeaway.png',
    'images/takeaways.png',
  ];
  final List<String> _string = [
    'ລາຍການອາຫານ',
    'ລາຍການອາຫານທີ່ລູກຄ້າສັ່ງ',
    'ຂໍ້ມູນຂອງຮ້ານອາຫານ',
  ];
  //final List<WidgetBuilder> _route = ['/listshop','/detailshop','/informationshop'];
  final List<Widget> _route = const [
    ListFoodShop(),
    DetailShop(),
    InformationShop(),
  ];
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          buildCaroselSlider(),
          buildTitle(),
          buildDetailShop(),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: height! * 0.10,
            width: width! * 0.80,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 198, 196, 196),
                  blurRadius: 3.0,
                  // spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-5, 0),
                ),
                BoxShadow(
                  color: Colors.white30,
                  offset: Offset(5, 0),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () => editapp(),
                  child: Text(
                    'ອອກຈາກລະບົບ',
                    style: MyStyle().lightStyle(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> editapp() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່?',
          style: MyStyle().primaryStyle(),
        ),
        children: [
          FlatButton(
            onPressed: () => signOut(context),
            child: Text(
              'ອອກຈາກລະບົບທັນທີ',
              style: MyStyle().lightStyle(),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ຍົກເລີກ',
              style: MyStyle().lightStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildTitle() {
    return Container(
        margin: const EdgeInsets.only(left: 30, top: 10),
        width: width,
        child: Text(
          'ສ່ວນລາຍລະອຽດຂອງຮ້ານອາຫານ',
          style: MyStyle().primaryStyle(),
        ));
  }

  Expanded buildDetailShop() {
    return Expanded(
      child: ListView.builder(
        itemCount: _string.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  _string[index],
                  style: MyStyle().lightStyle(),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: MyStyle().darkColor,
                ),
                onTap: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => _route[index]);
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildCaroselSlider() {
    return Container(
      // margin: EdgeInsets.only(top: 5),
      color: Colors.amber.shade500,
      height: height! * 0.30,
      child: CarouselSlider(
        items: _items
            .map((item) => Image.asset(
                  item,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ))
            .toList(),
        options: CarouselOptions(
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
          autoPlayInterval: const Duration(seconds: 4),
          viewportFraction: 0.8,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
