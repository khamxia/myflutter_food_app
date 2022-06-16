import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/food_models.dart';
import 'package:flutter_app/ngrok/my_ngrok.dart';
import 'package:flutter_app/style/mystyle.dart';
import 'package:flutter_app/widget/add_food_menu.dart';
import 'package:flutter_app/widget/edit_food_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodShop extends StatefulWidget {
  const ListFoodShop({Key? key}) : super(key: key);

  @override
  State<ListFoodShop> createState() => _ListFoodShopState();
}

class _ListFoodShopState extends State<ListFoodShop> {
  bool status = true;
  bool loadstatus = true;
  List<FoodModels> food_models = <FoodModels>[];
  double? width, height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (food_models.length != 0) {
      food_models.clear();
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? idshop = sharedPreferences.getString('id');
    print('idshop ==> $idshop');
    String url =
        '${MyNgrok().domainName}/fooddata/getUserWhereidshop.php?isAdd=true&idshop=$idshop';

    await Dio().get(url).then((value) {
      print('data ==> $value');
      setState(() {
        loadstatus = false;
      });
      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          FoodModels foodModel = FoodModels.fromJson(map);
          setState(() {
            food_models.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          loadstatus ? MyStyle().showProgress() : showContant(),
          addMenuButton(),
        ],
      ),
    );
  }

  Widget showContant() {
    return status
        ? showListFood()
        : MyStyle().titleCenter(
            context, 'ຍັງບໍ່ມີຂໍ້ມູນລາຍການອາຫານ ກະລຸນາເພີມລາຍການອາຫານ');
  }

  Widget showListFood() {
    return ListView.builder(
      itemCount: food_models.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                width: width! * 0.35,
                height: height! * 0.20,
                child: food_models == null
                    ? MyStyle().showProgress()
                    : Image.network(
                        '${MyNgrok().domainName}${food_models[index].pathimage}',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            
            Container(
              margin: EdgeInsets.all(10),
              // color: Colors.grey,
              width: width! * 0.50,
              height: height! * 0.20,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${food_models[index].namefood}',
                      style: MyStyle().lightStyle(),
                    ),
                    Text(
                      '${food_models[index].price}',
                      style: MyStyle().primaryStyle(),
                    ),
                    Text(
                      '${food_models[index].detail}',
                      style: MyStyle().primaryStyle(),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(
                                foodModels: food_models[index],
                              ),
                            );
                            Navigator.push(context, route)
                                .then((value) => readFoodMenu());
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteFood(food_models[index]),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                     
                  ],
                ),
              ),
            ),
          //  const  Divider(thickness: 1,color: Colors.black,),
         
          ],
        );
      },
    );
  }

  Future<Null> deleteFood(FoodModels foodModels) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        title: ListTile(
          leading: Image.asset('images/food.png'),
          title: Text(
            'ທ່ານຕ້ອງການລົບເມນູ ${foodModels.namefood}',
            style: MyStyle().lightStyle(),
          ),
          subtitle: Text(
            'ກະລຸນາກົດປຸ່ມເພີ່ອລົບເມນູອາຫານອອກ ແລະ ກົດປຸ່ມຍົກເລີກ',
            style: MyStyle().primaryStyle(),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyNgrok().domainName}/fooddata/getDeleteFoodMenu.php?isAdd=true&id=${foodModels.id}';
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text(
                  'ລົບອອກ',
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

  Column addMenuButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              child: FloatingActionButton(
                onPressed: () {
                  MaterialPageRoute pageRoute =
                      MaterialPageRoute(builder: (context) => AddFoodMenu());
                  Navigator.push(context, pageRoute)
                      .then((value) => readFoodMenu());
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
