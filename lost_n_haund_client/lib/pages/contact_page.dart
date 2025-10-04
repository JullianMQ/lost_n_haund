import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
                      "Contact Page",
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
                    "Campus Service\n campusservice@hau.edu.ph\nlocal 1177\n\n"
                    "Trunklines:\n (63) 045-625-5748\n (63) 045-625-9620\n (63) 045-625-9619\n\n"
                    "Fax Numbers:\n"
                    "888-2514 - President's Office\n"

                    "International Calls:\n"
                    "Please dial (+63-45) plus telephone number."
                    "National Calls:\n"
                    "Please dial (045) plus telephone number."

                    "\n\nMobile:\n 09190873327 (Smart)\n 09190873328 (Smart)\n 09190873329 (Smart)\n 09176320339 (Globe)\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      
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
