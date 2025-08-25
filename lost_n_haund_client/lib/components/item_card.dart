import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final String category;
  final String description;
  final String dateFound;
  final String locationFound;
  final String status;
  final String referenceId;

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.category,
    required this.description,
    required this.dateFound,
    required this.locationFound,
    required this.status,
    required this.referenceId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF7B001E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            child: Image.asset(
              imagePath,
              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemDetail("Item Name: $itemName"),
                itemDetail("Item Category: $category"),
                itemDetail("Description: $description"),
                itemDetail("Date Found: $dateFound"),
                itemDetail("Location Found: $locationFound"),
                itemDetail("Status: $status"),
                itemDetail("Reference ID: $referenceId"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDetail(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
