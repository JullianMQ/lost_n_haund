import 'package:flutter/material.dart';

class ClaimCard extends StatelessWidget {
  final String imagePath;
  final String claimantName;
  final String referenceId;
  final String justification;
  final String dateClaimed;
  final String location;
  final String status;
  final String claimId;
  final Map<String, dynamic> claimData;

  const ClaimCard({
    super.key,
    required this.imagePath,
    required this.claimantName,
    required this.referenceId,
    required this.justification,
    required this.dateClaimed,
    required this.location,
    required this.status,
    required this.claimId,
    required this.claimData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imagePath.isNotEmpty
                  ? Image.network(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "images/bg-hau.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    claimantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Ref: $referenceId",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    justification,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 4),
                      Text(location),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(dateClaimed.isNotEmpty ? dateClaimed : "N/A"),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: status == "approved"
                    ? Colors.green.shade100
                    : status == "rejected"
                        ? Colors.red.shade100
                        : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: status == "approved"
                      ? Colors.green.shade800
                      : status == "rejected"
                          ? Colors.red.shade800
                          : Colors.orange.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
