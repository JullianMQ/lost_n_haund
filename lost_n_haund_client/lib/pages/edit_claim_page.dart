import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class EditClaimPage extends StatefulWidget {
  final Map<String, dynamic> claimData;
  const EditClaimPage({super.key, required this.claimData});

  @override
  State<EditClaimPage> createState() => _EditClaimPageState();
}

class _EditClaimPageState extends State<EditClaimPage> {
  final _formKey = GlobalKey<FormState>();
  final _justificationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _userIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.claimData['first_name'] ?? '';
    _lastNameController.text = widget.claimData['last_name'] ?? '';
    _userEmailController.text = widget.claimData['user_email'] ?? '';
    _phoneNumberController.text = widget.claimData['phone_num'] ?? '';
    _userIdController.text = widget.claimData['user_id']?.toString() ?? '';
    _justificationController.text = widget.claimData['justification'] ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userEmailController.dispose();
    _phoneNumberController.dispose();
    _userIdController.dispose();
    _justificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.claimData['image_url'] != null &&
            widget.claimData['image_url'].toString().isNotEmpty)
        ? widget.claimData['image_url']
        : 'images/bg-hau.jpg';

    final claimId = widget.claimData['_id'] ?? '';
    final referenceId = widget.claimData['reference_id'] ?? 'N/A';
    final status =
        widget.claimData['approval'] == true ? 'Approved' : 'Pending';

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: const CustomDrawer(isAdmin: false),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("images/bg-hau.jpg", fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Claim',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(color: Colors.white70, thickness: 1.5),
                      const SizedBox(height: 8),

                      Text(
                        "Reference ID: $referenceId",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'images/bg-hau.jpg',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Claim Information",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(color: Colors.white70),
                      _buildInfoRow("Claim ID", claimId),
                      _buildInfoRow("Status", status),
                      const SizedBox(height: 20),

                      const Text(
                        "Editable Details",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(color: Colors.white70),
                      const SizedBox(height: 12),

                      _buildInputField(
                        controller: _firstNameController,
                        label: "First Name",
                        validatorMsg: "First name is required",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _lastNameController,
                        label: "Last Name",
                        validatorMsg: "Last name is required",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _userEmailController,
                        label: "Email",
                        validatorMsg: "Email is required",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _phoneNumberController,
                        label: "Phone Number",
                        validatorMsg: "Phone number is required",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _userIdController,
                        label: "User ID",
                        validatorMsg: "User ID is required",
                      ),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _justificationController,
                        label: "Justification",
                        validatorMsg: "Justification is required",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      if (_isLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton(
                              text: "Cancel",
                              color: Colors.grey[600]!,
                              onPressed: () => Navigator.pop(context),
                            ),
                            _buildButton(
                              text: "Save Changes",
                              color: Colors.orange,
                              onPressed: _saveChanges,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String validatorMsg,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        fillColor: Color(0xFF7B001E),
        filled: true,
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? validatorMsg : null,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final updatedData = {
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'user_email': _userEmailController.text.trim(),
      'phone_num': _phoneNumberController.text.trim(),
      'user_id': _userIdController.text.trim(),
      'reference_id': widget.claimData['reference_id'],
      'justification': _justificationController.text.trim(),
    };

    try {
      final postService = PostService();
      final response =
          await postService.updateClaim(widget.claimData['_id'], updatedData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Claim updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: ${response.data['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating claim: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  static Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
