import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 75, 
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // Image.asset(
            //   "assets/twiceLogo.jpg", 
            //   height: 40,
            // ),
            const SizedBox(width: 10),
            const Text(
              "HOLY ANGEL\nUNIVERSITY",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF800020)),
            onPressed: () {
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/holy.jpg"), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF800000), 
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Lost N Haund is a digital solution developed by Group RAWR to improve the process of locating and reclaiming the lost items within Holy Angel University. Our goal is to reduce the frustration and inefficiency of the traditional manual lost-and-found system by introducing a modern user-friendly platform accessible to students, teachers, and school administrators.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
