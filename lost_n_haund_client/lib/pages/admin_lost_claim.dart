import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';

class AdminLostClaim extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  AdminLostClaim({super.key});

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: CustomDrawer(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Stack(
              children: [
                Image.asset(
                  'images/bg-hau.jpg', 
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B001E),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Search for Claims",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      MyTextfield(
                        controller: nameController,
                        hintText: 'User, Email, Phone',
                        obscureText: false,
                        maxLines: 1,
                      ),

                      const SizedBox(height: 15),

                    ],
                  ),
                ),
              ],
            ),

            Container(
              color: const Color(0xFF7B001E),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: Text(
                  "Claims",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ItemCard(
            //   imagePath: 'images/bg-hau.jpg',
            //   itemName: 'Nandito',
            //   category: 'Ako',
            //   description: 'umiibig sayo',
            //   dateFound: '2025-08-24',
            //   locationFound: 'kahit na nagduro ang puso',
            //   status: 'at kung sakali iwanan ka niyaaa',
            //   referenceId: 'wag kang mag-alala nandito akoooo',
            // ),
          ],
        ),
      ),
    );
  }
}
