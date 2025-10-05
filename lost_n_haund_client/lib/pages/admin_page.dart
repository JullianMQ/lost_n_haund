import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/filter_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/filter_claim.dart';
import 'package:lost_n_haund_client/components/claim_card.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final nameController = TextEditingController();
  final userIdController = TextEditingController();
  final ownerIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ClaimFilterProvider>(context, listen: false).fetchClaims();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<ClaimFilterProvider>(context);

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
                height: 300, 
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
                      "Search Claims",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                  MyTextfield(
                    controller: nameController,
                    hintText: 'Claimant Name',
                    obscureText: false,
                    maxLines: 1,
                    onChanged: (val) {
                      context.read<ClaimFilterProvider>().setName(val);
                    },
                  ),
                    const SizedBox(height: 10),

                    MyTextfield(
                      controller: userIdController,
                      hintText: 'User ID',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        context.read<ClaimFilterProvider>().setUserId(val);
                      },
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterButton(
                          text: "Sort by Date",
                          onPressed: () {
                            filterProvider.sortByDate();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Claims Header
          Container(
            color: const Color(0xFF7B001E),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(
              child: Text(
                "Claims",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Claims List
          Expanded(
            child: Consumer<ClaimFilterProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.claims.isEmpty) {
                  return const Center(
                    child: Text("No claims found"),
                  );
                }

                return ListView.builder(
                  itemCount: provider.claims.length,
                  itemBuilder: (context, index) {
                    final claim = provider.claims[index] as Map<String, dynamic>;

                    return ClaimCard(
                      imagePath: claim['image_url'] ?? "",
                      claimantName:
                          "${claim['first_name'] ?? ''} ${claim['last_name'] ?? ''}",
                      referenceId: claim['reference_id'] ?? "N/A",
                      justification: claim['justification'] ?? "No justification",
                      dateClaimed: claim['date_found'] ?? claim['createdAt'] ?? "",
                      location: claim['location'] ?? "Unknown",
                      status: claim['status'] ?? "pending",
                      claimId: claim['_id'] ?? 'N/A',
                      claimData: claim,
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
