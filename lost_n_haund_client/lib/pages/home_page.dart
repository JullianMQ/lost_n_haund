import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/filter_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/item_card.dart';
import 'package:lost_n_haund_client/services/api_services.dart';
import 'package:dio/dio.dart';

class HomePage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  HomePage({super.key});

  final nameController = TextEditingController();
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: CustomDrawer(),

      body: Column(
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 25,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
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

          // ItemCard(
          //   imagePath: 'images/bg-hau.jpg',
          //   itemName: "cniseah",
          //   category: "cniseah",
          //   description: "cniseah",
          //   dateFound: "cniseah",
          //   locationFound: "cniseah",
          //   status: "cniseah",
          //   referenceId: "cniseah",
          // ),
          Expanded(
            child: FutureBuilder(
              future: api.getPosts(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (asyncSnapshot.hasError) {
                  return Text("Error retrieving items");
                }

                final res = asyncSnapshot.data as Response;
                final itemPosts = res.data as List<dynamic>;

                return ListView.builder(
                  itemCount: itemPosts.length,
                  itemBuilder: (context, index) {
                    final itemPost = itemPosts[index] as Map<String, dynamic>;

                    return ItemCard(
                      imagePath: 'images/bg-hau.jpg',
                      itemName: itemPost['item_name'],
                      category: "${itemPost['item_category']}",
                      description: itemPost['description'],
                      dateFound: itemPost['date_found'],
                      locationFound: itemPost['location_found'],
                      status: itemPost['status'],
                      referenceId: itemPost['_id'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
