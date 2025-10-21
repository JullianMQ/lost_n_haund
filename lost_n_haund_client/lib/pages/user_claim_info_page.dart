import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/pages/claims_users.dart'; 
// import 'package:lost_n_haund_client/pages/edit_claim_page.dart'; // Uncomment when you create EditClaimPage

class UserItemInfo extends StatelessWidget {
  const UserItemInfo({super.key, required this.itemData});
  final Map<String, dynamic> itemData;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (itemData['image_url'] != null &&
            itemData['image_url'].toString().isNotEmpty)
        ? itemData['image_url']
        : 'images/bg-hau.jpg';
    final isPending = itemData['approval'] != true; 

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: const CustomDrawer(isAdmin: false), 
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
                      'My Claim Details',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Divider(color: Colors.white70, thickness: 1.5),
                    const SizedBox(height: 6),

                    Text(
                      itemData['reference_id'] ?? 'No Reference ID',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(color: Colors.white),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/bg-hau.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
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

                    _buildInfoRow(
                      "Claimant Name",
                      "${itemData['first_name'] ?? ''} ${itemData['last_name'] ?? ''}",
                    ),
                    _buildInfoRow("User Email", itemData['user_email'] ?? 'N/A'),
                    _buildInfoRow("Phone Number", itemData['phone_num'] ?? 'N/A'),
                    _buildInfoRow("User ID", itemData['user_id'] ?? 'N/A'),
                    _buildInfoRow(
                        "Justification", itemData['justification'] ?? 'N/A'),
                    _buildInfoRow("Claim ID", itemData['_id'] ?? 'N/A'),
                    _buildInfoRow("Status", itemData['approval'] == true ? 'Approved' : 'Pending'),

                    const SizedBox(height: 20),

                    if (isPending)
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); 
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserClaimsPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          "Back to Claims",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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