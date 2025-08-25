import 'package:flutter/material.dart';

class AcceptDenyButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const AcceptDenyButtons({
    super.key,
    required this.onAccept,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ACCEPT BUTTON
        ElevatedButton.icon(
          onPressed: onAccept,
          label: const Text("Accept", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),

        // DENY BUTTON
        ElevatedButton.icon(
          onPressed: onDeny,
          label: const Text("Deny", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF800000),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }
}
