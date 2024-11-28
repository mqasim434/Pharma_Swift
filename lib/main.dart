// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:pharmacy_pos/database/db_helper.dart';
import 'package:pharmacy_pos/models/purchase_model.dart';
import 'package:pharmacy_pos/screens/dashboard.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setTitle("Pharma Swift");
  await DBHelper.init();
  await Hive.openBox<PurchaseModel>('purchases');
  await Hive.openBox<int>('purchase_ids');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Dashboard(),
    );
  }
}
