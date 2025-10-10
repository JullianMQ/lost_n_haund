import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/components/claim_card.dart';
import 'package:lost_n_haund_client/components/filter_button.dart';
import 'package:lost_n_haund_client/components/filter_claim.dart';
import 'package:provider/provider.dart';


class UserClaimsPage extends StatefulWidget {
  const UserClaimsPage({super.key});

  @override
  State<UserClaimsPage> createState() => _UserClaimsPageState();
}

class _UserClaimsPageState extends State<UserClaimsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userIdController = TextEditingController();
  final ownerIdController = TextEditingController();
  bool showApproved = false;

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
      endDrawer: const CustomDrawer(isAdmin: false),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Stack(
            children: [
              Image.asset(
                'images/bg-hau.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 340,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                padding: const EdgeInsets.all(15),
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
                      controller: firstNameController,
                      hintText: 'First Name',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        context
                            .read<ClaimFilterProvider>()
                            .setFirstName(val);
                      },
                    ),

                    const SizedBox(height: 10),

                    MyTextfield(
                      controller: lastNameController,
                      hintText: 'Last Name',
                      obscureText: false,
                      maxLines: 1,
                      onChanged: (val) {
                        context
                            .read<ClaimFilterProvider>()
                            .setLastName(val);
                      },
                    ),

                    const SizedBox(height: 15),
                    const Text(
                      "My Claims",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterButton(
                          text: "Sort by Date",
                          onPressed: () {
                            filterProvider.sortByDate();
                          },
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              showApproved = !showApproved;
                            });
                          },
                          icon: Icon(
                            showApproved
                                ? Icons.list_alt
                                : Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            showApproved ? "Show Pending" : "Show Approved",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                showApproved ? Colors.orange : Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Container(
            color: const Color(0xFF7B001E),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                showApproved ? "Approved Claims" : "Pending Claims",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: Consumer<ClaimFilterProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filteredClaims = provider.claims
                    .where((claim) => showApproved
                        ? claim['approval'] == true
                        : claim['approval'] != true)
                    .toList();

                if (filteredClaims.isEmpty) {
                  return Center(
                    child: Text(
                      showApproved
                          ? "No approved claims found."
                          : "No pending claims found.",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredClaims.length,
                  itemBuilder: (context, index) {
                    final claim = filteredClaims[index];
                    return ClaimCard(
                      imagePath: claim['image_url'] ?? "",
                      claimantName:
                          "${claim['first_name'] ?? ''} ${claim['last_name'] ?? ''}",
                      referenceId: claim['reference_id'] ?? "N/A",
                      justification:
                          claim['justification'] ?? "No justification",
                      dateClaimed:
                          claim['date_found'] ?? claim['createdAt'] ?? "",
                      location: claim['location'] ?? "Unknown",
                      status: claim['approval'] == true
                          ? "Approved"
                          : "Pending",
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
