import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/pages/admin_item_info.dart';
import 'package:lost_n_haund_client/pages/user_claim_info_page.dart';
import 'package:lost_n_haund_client/services/post_service.dart'; 

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
  final VoidCallback? onDeleted; 

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
    this.onDeleted,
  });

  Future<void> _deleteClaim(BuildContext context) async {
    if (claimId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Claim ID not found')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Claim'),
        content: const Text('Are you sure you want to delete this claim? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final postService = PostService();
        final response = await postService.deleteClaim(claimId!);

        if (response.containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete claim: ${response['error']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Claim deleted successfully')),
          );

          onDeleted?.call();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting claim: $e')),
        );
      }
    }
  }

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

            if (isUser)
              Column(
                children: [
                  if (onEdit != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onEdit,
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B001E),
                        foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: const Text("Edit Claim"),
                      ),
                    ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _deleteClaim(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B001E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: const Text("Delete Claim"),
                    ),
                  ),

                  const SizedBox(height: 8),

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
                              builder: (_) => UserItemInfo(itemData: safeClaimData),
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
              )
            else
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
                          builder: (_) => AdminItemInfo(itemData: safeClaimData),
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
                  child: const Text("More Info"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
