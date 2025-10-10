import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/users_card.dart';
import 'package:lost_n_haund_client/components/filter_users.dart';
import 'package:lost_n_haund_client/pages/user_info_page.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  final nameController = TextEditingController();
  final userIdController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserFilterProvider>(context, listen: false).fetchUsers();
    });
  }

  void _triggerSearch(UserFilterProvider provider) {
    provider.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserFilterProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: const CustomDrawer(isAdmin: true),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Stack(
            children: [
              Image.asset(
                'images/bg-hau.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 370,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B001E),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Search for Users",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    MyTextfield(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        provider.setName(val);
                        _triggerSearch(provider);
                      },
                    ),
                    const SizedBox(height: 10),

                    MyTextfield(
                      controller: userIdController,
                      hintText: 'User ID',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        provider.setUserId(val);
                        _triggerSearch(provider);
                      },
                    ),
                    const SizedBox(height: 10),

                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        provider.setEmail(val);
                        _triggerSearch(provider);
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),

          Container(
            color: const Color(0xFF7B001E),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(
              child: Text(
                "User List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.users.isEmpty
                  ? const Center(
                    child: Text(
                      "No users found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        final name = user['name'] ?? 'No Name';
                        final id = user['user_id']?.toString() ?? 'N/A';
                        final email = user['email'] ?? 'N/A';
                        final password = user['password'] ?? 'N/A';
                        
                        return UserCard(
                          name: name,
                          userId: id,
                          email: email,
                          password: password,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserInfoPage(userData: {
                                  'name': name,
                                  'id': id,
                                  'email': email,
                                  'password': password,
                                  '_id': user['_id'] ?? '',
                                }),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
