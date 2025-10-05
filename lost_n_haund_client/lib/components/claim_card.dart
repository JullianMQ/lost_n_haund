import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/admin_item_info.dart';

class ClaimCard extends StatelessWidget {
  final String? imagePath;
  final String? claimantName;
  final String? referenceId;
  final String? justification;
  final String? dateClaimed;
  final String? location;
  final String? status;
  final String? claimId;
  final Map<String, dynamic>? claimData;

  const ClaimCard({
    super.key,
    this.imagePath,
    this.claimantName,
    this.referenceId,
    this.justification,
    this.dateClaimed,
    this.location,
    this.status,
    this.claimId,
    this.claimData,
  });

  @override
  Widget build(BuildContext context) {
    final safeImage = (imagePath != null && imagePath!.isNotEmpty)
        ? imagePath!
        : "images/bg-hau.jpg";
    final safeClaimData = claimData ?? {};

    return Card(
      color: const Color(0xFF7B001E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: safeImage.startsWith("http")
                  ? Image.network(
                      safeImage,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "images/bg-hau.jpg",
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      safeImage,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 10),

            Text(claimantName ?? "Unknown Claimant",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Reference ID: ${referenceId ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Claim ID: ${claimId ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Justification: ${justification ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Status: ${status ?? '-'}", style: const TextStyle(color: Colors.white)),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (safeClaimData.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminItemInfo(itemData: safeClaimData),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No claim data available')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7B001E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
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
