import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screen/authen.dart';
import 'package:flutter_app/screen/mainrider.dart';
import 'package:flutter_app/screen/mainshop.dart';
import 'package:flutter_app/screen/mainuser.dart';
import 'package:flutter_app/widget/detail_shop.dart';
import 'package:flutter_app/widget/information_shop.dart';
import 'package:flutter_app/widget/list_food_shop.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (context) => Authen(),
  '/mainshop': (context) => MainShop(),
  '/mainuser': (context) => MainUser(),
  '/mainrider': (context) => MainRider(),
  '/informationshop':(context)=>InformationShop(),
  '/listshop':(context)=>ListFoodShop(),
  '/detailshop':(context)=>DetailShop(),
};
