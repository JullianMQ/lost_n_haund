import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        ElevatedButton.icon(
          onPressed: onEdit,
          label: const Text("Edit", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF800000),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: onDelete,
          label: const Text("Delete", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF800000),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
