import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/filter_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/item_card.dart';
import 'package:lost_n_haund_client/components/filter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔹 Background + Search + Filters
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
                      onChanged: (val) {
                        // Optional: Implement search logic in provider later
                      },
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 🔹 Date Sort Button
                        FilterButton(
                          text: "Date",
                          onPressed: () {
                            filterProvider.sortByDate();
                          },
                        ),

                        // 🔹 Category Dropdown
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            filterProvider.setCategory(value == "All" ? "" : value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "All",
                              child: Text("All"),
                            ),
                            const PopupMenuItem(
                              value: "Backpack",
                              child: Text("Backpack"),
                            ),
                            const PopupMenuItem(
                              value: "Phone",
                              child: Text("Phone"),
                            ),
                            const PopupMenuItem(
                              value: "ID",
                              child: Text("ID"),
                            ),
                          ],
                          child: const FilterButton(text: "Category"),
                        ),

                        // 🔹 Location Dropdown
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            filterProvider.setLocation(value == "All" ? "" : value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "All",
                              child: Text("All"),
                            ),
                            const PopupMenuItem(
                              value: "Library",
                              child: Text("Library"),
                            ),
                            const PopupMenuItem(
                              value: "Gym",
                              child: Text("Gym"),
                            ),
                            const PopupMenuItem(
                              value: "Canteen",
                              child: Text("Canteen"),
                            ),
                          ],
                          child: const FilterButton(text: "Location"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🔹 Section Title
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

          // 🔹 Post List (Listens to FilterProvider)
          Expanded(
            child: Consumer<FilterProvider>(
              builder: (context, provider, child) {
                if (provider.posts.isEmpty) {
                  return const Center(
                    child: Text("No items found"),
                  );
                }
                return ListView.builder(
                  itemCount: provider.posts.length,
                  itemBuilder: (context, index) {
                    final itemPost = provider.posts[index] as Map<String, dynamic>;

                    final imagePath = (itemPost['image_url'] != null &&
                            itemPost['image_url'].toString().isNotEmpty)
                        ? itemPost['image_url']
                        : 'images/bg-hau.jpg';

                    return ItemCard(
                      imagePath: itemPost['image_url'] ?? "",
                      itemName: itemPost['item_name'],
                      category: "${itemPost['item_category']}",
                      description: itemPost['description'],
                      dateFound: itemPost['date_found'],
                      locationFound: itemPost['location_found'],
                      status: itemPost['status'],
                      referenceId: itemPost['_id'],
                      itemData: itemPost,
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
