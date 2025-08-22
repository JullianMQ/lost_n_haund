import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';
import 'package:lost_n_haund_client/pages/contact_page.dart';
import 'package:lost_n_haund_client/pages/about_us.dart';

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
      home: AboutUsPage(),
    );
  }
}

