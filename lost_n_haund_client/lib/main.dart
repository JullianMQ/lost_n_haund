import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/admin_item_info.dart';
import 'package:lost_n_haund_client/pages/admin_lost_claim.dart';
import 'package:lost_n_haund_client/pages/admin_item_claim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AdminItemAccept(),
    );
  }
}

