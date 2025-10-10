import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String userId;
  final String email;
  final String password;
  final VoidCallback? onEdit;

  const UserCard({
    super.key,
    required this.name,
    required this.userId,
    required this.email,
    required this.password,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF7B001C), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoText("User Name: $name"),
                _infoText("User ID: $userId"),
                _infoText("User Email: $email"),
                _infoText(
                  "User Password: ${password != null && password.toString().isNotEmpty 
                      ? '•••••••• (Hidden)' 
                      : 'Not Set'}",
                ),
              ],
            ),
          ),

          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 1.5),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onEdit,
              child: const Text(
                "Edit User",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
