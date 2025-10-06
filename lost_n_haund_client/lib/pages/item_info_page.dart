import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/pages/form_page.dart';

class ItemInfoPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const ItemInfoPage({super.key, required this.itemData});

  String formatDate(dynamic dateValue) {
  if (dateValue == null) return 'N/A';
  try {
    final date = DateTime.parse(dateValue.toString());
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  } catch (e) {
    return dateValue.toString(); 
  }
}

  @override
  Widget build(BuildContext context) {
    final imageUrl = (itemData['image_url'] != null &&
        itemData['image_url'].toString().isNotEmpty)
        ? itemData['image_url']
        : 'images/bg-hau.jpg';

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: CustomDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/bg-hau.jpg",
            fit: BoxFit.cover,
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Item Info',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Divider(color: Colors.white70, thickness: 1.5),
                    const SizedBox(height: 8),

                    Text(
                      "Reference ID: ${itemData['_id'] ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imageUrl.startsWith('http')
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Image.asset(imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Divider(color: Colors.white70, thickness: 1.2),
                    const SizedBox(height: 12),

                    _buildInfoRow("Item Name", itemData['item_name'] ?? 'N/A'),
                    _buildInfoRow(
                      "Item Category",
                      (itemData['item_category'] as List).join(", "),
                    ),
                    _buildInfoRow("Description", itemData['description'] ?? 'N/A'),
                    _buildInfoRow("Date Found", formatDate(itemData['date_found'])),
                    _buildInfoRow(
                        "Location Found", itemData['location_found'] ?? 'N/A'),
                    _buildInfoRow("Status", itemData['status'] ?? 'N/A'),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FormPage(referenceId: itemData['_id']),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B0000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: const Text(
                          "Claim Item",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
