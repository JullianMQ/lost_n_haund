import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/admin_item_info.dart';
import 'package:lost_n_haund_client/pages/user_claim_info_page.dart';

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

  final bool isUser;
  final VoidCallback? onEdit;
  final Function(Map<String, dynamic>)? onMoreInfo;
  final Future<void> Function()? onDelete; // ✅ NEW

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
    this.isUser = false,
    this.onEdit,
    this.onMoreInfo,
    this.onDelete, // ✅ NEW
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
            Stack(
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

                // ✅ Popup menu for Edit/Delete
                if (isUser)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Claim'),
                              content: const Text('Are you sure you want to delete this claim?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await onDelete!();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              claimantName ?? "Unknown Claimant",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("Reference ID: ${referenceId ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Claim ID: ${claimId ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Justification: ${justification ?? '-'}", style: const TextStyle(color: Colors.white)),
            Text("Status: ${status ?? '-'}", style: const TextStyle(color: Colors.white)),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (onMoreInfo != null) {
                    onMoreInfo!(safeClaimData);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isUser
                            ? UserItemInfo(itemData: safeClaimData)
                            : AdminItemInfo(itemData: safeClaimData),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B001E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
