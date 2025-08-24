import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/claim_form_page.dart';
import 'package:lost_n_haund_client/pages/contact_page.dart';
import 'package:lost_n_haund_client/pages/about_us_page.dart';

// Custom Drawer
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF800020), 
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

              buttonOption(
                context,
                "Claim Form",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClaimForm()),
                  );
                },
              ),
              buttonOption(
                context,
                "About",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },
              ),

            buttonOption(
                context,
                "Contact Us",
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );
                },
              ),

              const Spacer(),
              const Text(
                "© 2025 HAU",
                style: TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonOption(BuildContext context, String text, {VoidCallback? onTap}) {
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
        onPressed: onTap ?? () => Navigator.pop(context),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

}

// Header
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
        IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF800020)),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); 
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}
