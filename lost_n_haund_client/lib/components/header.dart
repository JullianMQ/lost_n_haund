import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/admin_users.dart';
import 'package:lost_n_haund_client/pages/form_page.dart';
import 'package:lost_n_haund_client/pages/contact_page.dart';
import 'package:lost_n_haund_client/pages/about_us_page.dart';
import 'package:lost_n_haund_client/pages/home_page.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';
import 'package:lost_n_haund_client/pages/admin_page.dart';

class CustomDrawer extends StatelessWidget {
  final bool isAdmin;
  const CustomDrawer({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF800020),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("images/logo.jpg", height: 50),
                  const SizedBox(width: 10),
                  const Text(
                    "HOLY ANGEL\nUNIVERSITY",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: isAdmin
                      ? [
                          buttonOption(context, "Dashboard", AdminPage()),
                          buttonOption(context, "Users", AdminUserPage()),
                        ]
                      : [
                          buttonOption(context, "Home", HomePage()),
                          buttonOption(context, "Form", FormPage()),
                          buttonOption(context, "About", AboutUsPage()),
                          buttonOption(context, "Contact Us", ContactPage()),
                        ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false, 
                    );
                  },
                  child: const Text("Logout", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 10),
              Text(
                isAdmin ? "© 2025 HAU Admin" : "© 2025 HAU",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonOption(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF800020),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        onPressed: () {
          Navigator.pop(context); 
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 75,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "images/logo.jpg",
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "HOLY ANGEL\nUNIVERSITY",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF800020)),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}
