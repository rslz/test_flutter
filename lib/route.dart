import 'package:flutter/material.dart';
import 'goods_detail.dart';
import 'saveList.dart';
class MWRouter{
  static final Map<String,WidgetBuilder> routes = {
    //商品详情
    "/goods/detail": (context) => GoodsDetail(),
    "/saveList": (context) => MyApp(),
  };
}