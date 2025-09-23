import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/item_info_page.dart';

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final String category;
  final String description;
  final String dateFound;
  final String locationFound;
  final String status;
  final String referenceId;
  final Map<String, dynamic> itemData;

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
    required this.itemData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF800000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            Text(itemName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Category: $category", style: const TextStyle(color: Colors.white)),
            Text(description, style: const TextStyle(color: Colors.white)),
            Text("Date Found: $dateFound", style: const TextStyle(color: Colors.white)),
            Text("Location Found: $locationFound", style: const TextStyle(color: Colors.white)),
            Text("Status: $status", style: const TextStyle(color: Colors.white)),
            Text("Reference ID: $referenceId", style: const TextStyle(color: Colors.white)),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemInfoPage(itemData: itemData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B001E),
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.white, width: 2)),
                ),
                child: const Text("More Info"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
