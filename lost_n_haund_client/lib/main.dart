import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';
import 'package:lost_n_haund_client/components/filter_post.dart';
import 'package:lost_n_haund_client/components/filter_claim.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostFilterProvider()),
        ChangeNotifierProvider(create: (_) => ClaimFilterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, 
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginPage(),
    );
  }
}
