import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lost_n_haund_client/pages/admin_users.dart';
import 'package:lost_n_haund_client/pages/form_page.dart';
import 'package:lost_n_haund_client/pages/contact_page.dart';
import 'package:lost_n_haund_client/pages/about_us_page.dart';
import 'package:lost_n_haund_client/pages/home_page.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';
import 'package:lost_n_haund_client/pages/admin_page.dart';
import 'package:lost_n_haund_client/pages/claims_users.dart';

class CustomDrawer extends StatefulWidget {
  final bool isAdmin;

  const CustomDrawer({super.key, this.isAdmin = false});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? prefs.getString('name') ?? "User";
    });
  }

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "HOLY ANGEL\nUNIVERSITY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (username != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "@$username",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: widget.isAdmin
                      ? [
                          buttonOption(context, "Dashboard", AdminPage()),
                          buttonOption(context, "Users", const AdminUserPage()),
                        ]
                      : [
                          buttonOption(context, "Home", HomePage()),
                          buttonOption(context, "Form", const FormPage()),
                          buttonOption(context, "About", const AboutUsPage()),
                          buttonOption(context, "Claims", const UserClaimsPage()),
                          buttonOption(context, "Contact Us", const ContactPage()),
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); 

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
                widget.isAdmin ? "© 2025 HAU Admin" : "© 2025 HAU",
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
  final String titleLine1;
  final String? titleLine2;
  final Widget? trailing;

  const Header({
    super.key,
    this.titleLine1 = "HOLY ANGEL",
    this.titleLine2 = "UNIVERSITY",
    this.trailing,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$titleLine1",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (titleLine2 != null)
                  Text(
                    "$titleLine2",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: trailing!,
          )
        else
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF800020)),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

