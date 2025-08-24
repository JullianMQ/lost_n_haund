import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(75), child: Header()),
      endDrawer: CustomDrawer(),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg-hau.jpg"), 
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Center(
                    child: Text(
                      "About Us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), 
                  Text(
                    "Lost N Haund is a digital solution developed by Group KAWR to improve the process of locating and retrieving lost items within the campus premises. Our goal is to reduce the frustration and inefficiency of the traditional manual lost-and-found system by introducing a modern, user-friendly platform accessible to students, teachers, and school administrators. \n\n"
                    "We believe that lost items shouldn't stay lost. By leveraging technology, we aim to:\n\n"
                    " • Help owners identify and claim their items faster\n"
                    " • Assist finders in managing reports and returns more efficiently\n"
                    " • Create a transparent and accountable lost-and-found system\n\n"
                    "With features like online item listings, Lost N Haund streamlines both recovery and classroom participation—making campus life safer, smarter, and more connected.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
