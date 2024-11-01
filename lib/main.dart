// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/database/db_helper.dart';
import 'package:pharmacy_pos/database/products_db_helper.dart';
import 'package:pharmacy_pos/screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.init();
  Get.put(ProductsDBController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Dashboard(),
      ),
    );
  }
}
