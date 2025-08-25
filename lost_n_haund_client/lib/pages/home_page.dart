import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/filter_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/item_card.dart';

class HomePage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  HomePage({super.key});

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
                        "Search for Items",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      MyTextfield(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        maxLines: 1,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilterButton(
                            text: "Date",
                            onPressed: () {
                              print("Filter by Date");
                            },
                          ),
                          FilterButton(
                            text: "Category",
                            onPressed: () {
                              print("Filter by Category");
                            },
                          ),
                          FilterButton(
                            text: "Location",
                            onPressed: () {
                              print("Filter by Location");
                            },
                          ),
                        ],
                      ),
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
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            ItemCard(
              imagePath: 'images/bg-hau.jpg',
              itemName: 'Nandito',
              category: 'Ako',
              description: 'umiibig sayo',
              dateFound: '2025-08-24',
              locationFound: 'kahit na nagduro ang puso',
              status: 'at kung sakali iwanan ka niyaaa',
              referenceId: 'wag kang mag-alala nandito akoooo',
            ),
          ],
        ),
      ),
    );
  }
}
