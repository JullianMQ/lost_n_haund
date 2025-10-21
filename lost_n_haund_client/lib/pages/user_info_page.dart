import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/services/post_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserInfoPage({super.key, required this.userData});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late bool isBanned;
  late String name;
  late String id;
  late String email;

  @override
  void initState() {
    super.initState();
    name = widget.userData['name'] ?? 'Unknown User';
    id = widget.userData['_id']?.toString() ?? '-';
    email = widget.userData['email'] ?? '-';
    isBanned = widget.userData['banned'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7B001C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF7B001C),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoText('User Name: $name'),
              _infoText('User ID: $id'),
              _infoText('Email: $email'),
              _infoText('Status: ${isBanned ? 'BANNED' : 'ACTIVE'}'),
              const SizedBox(height: 20),

              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _actionButton(
                      context,
                      label: isBanned ? 'Unban User' : 'Ban User',
                      color: isBanned ? Colors.green : Colors.red,
                      onPressed: () async {
                        if (isBanned) {
                          await _unbanUser(context, id);
                        } else {
                          _showBanDialog(context, id);
                        }
                      },
                    ),
                    // _actionButton(
                    //   context,
                    //   label: 'Update User',
                    //   color: Colors.blue,
                    //   onPressed: () {
                    //     _showUpdateDialog(context, name);
                    //   },
                    // ),
                    _actionButton(
                      context,
                      label: 'Delete User',
                      color: Colors.black,
                      onPressed: () {
                        _confirmDelete(context, name);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 15)),
    );
  }

  void _showUpdateDialog(BuildContext context, String currentName) {
    final nameController = TextEditingController(text: currentName);
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('auth_token') ?? '';

              try {
                await PostService().updateUser(
                  name: nameController.text.trim(),
                  image: imageController.text.trim(),
                  token: token,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User updated successfully.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update user: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B001C),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBanDialog(BuildContext context, String userId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ban User'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Ban Reason',
            hintText: 'Enter reason for banning...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('auth_token') ?? '';

              try {
                await PostService().banUser(
                  id: userId,
                  token: token,
                  reason: reasonController.text.trim().isEmpty
                      ? 'No reason provided'
                      : reasonController.text.trim(),
                );

                setState(() {
                  isBanned = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User has been banned successfully.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to ban user: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ban'),
          ),
        ],
      ),
    );
  }

  Future<void> _unbanUser(BuildContext context, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      await PostService().unbanUser(id: userId, token: token);
      setState(() {
        isBanned = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User has been unbanned successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unban user: $e')),
      );
    }
  }

  void _confirmDelete(BuildContext context, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final currentUserEmail = prefs.getString('user_email') ?? '';
    final userEmailToDelete = widget.userData['email'] ?? '';
    final mongoId = widget.userData['_id']?.toString() ?? '';

    if (mongoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid user ID for deletion.')),
      );
      return;
    }

    if (userEmailToDelete == currentUserEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can't delete your own admin account.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await PostService().removeUser(
                  id: mongoId,
                  token: token,
                  email: userEmailToDelete,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted successfully.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete user: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
