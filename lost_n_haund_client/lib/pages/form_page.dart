import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/services/post_service.dart';

class FormPage extends StatefulWidget {
  final String? referenceId;
  const FormPage({super.key, this.referenceId});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final formKey = GlobalKey<FormState>();

  // Claim Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final studentController = TextEditingController();
  final claimController = TextEditingController();

  // Lost Item Form Controllers
  final itemNameController = TextEditingController();
  final itemCategoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateFoundController = TextEditingController();
  final locationFoundController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Form Type Selector
  String _formType = "claim"; // Default: Claim Form

  void resetForm() {
    formKey.currentState?.reset();

    // Claim controllers
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    contactController.clear();
    studentController.clear();
    claimController.clear();

    // Lost item controllers
    itemNameController.clear();
    itemCategoryController.clear();
    descriptionController.clear();
    dateFoundController.clear();
    locationFoundController.clear();

    // Reset image
    setState(() {
      _selectedImage = null;
    });
  }

  // Image Picker Function
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Photo Uploaded!")));
    }
  }

  // Claim Form Widget
  Widget _buildClaimForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First Name
        Row(
          children: const [
            Text(
              "First Name:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: firstNameController,
          hintText: 'First Name',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        // Last Name
        Row(
          children: const [
            Text(
              "Last Name:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: lastNameController,
          hintText: 'Last Name',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        // Email
        Row(
          children: const [
            Text(
              "Email:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: emailController,
          hintText: 'Email',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        // Contact
        Row(
          children: const [
            Text(
              "Contact No:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: contactController,
          hintText: 'Contact No.',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        // Student No.
        Row(
          children: const [
            Text(
              "Student No:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: studentController,
          hintText: 'Student No.',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        // Reference ID Upload
        Row(
          children: [
            Text(
              "Reference Photo/ID: ${widget.referenceId}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (_selectedImage != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedImage!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800000),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
            onPressed: _pickImage,
            child: const Text("Upload Photo"),
          ),
        ),
        const Divider(color: Colors.white, thickness: 2),

        // Claim Justification
        Row(
          children: const [
            Text(
              "Claim Justification:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: claimController,
          hintText: 'Insert Claim here',
          maxLines: 5,
        ),
      ],
    );
  }

  // Lost Item Form Widget
  Widget _buildLostForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: const [
            Text(
              "Item Name:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: itemNameController,
          hintText: 'Item Name',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        Row(
          children: const [
            Text(
              "Item Category:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: itemCategoryController,
          hintText: 'Item Category',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        Row(
          children: const [
            Text(
              "Description:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: descriptionController,
          hintText: 'Description',
          maxLines: 3,
        ),
        const SizedBox(height: 15),

        Row(
          children: const [
            Text(
              "Date Found:(YYYY-MM-DD)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: dateFoundController,
          hintText: 'Date Found: (YYYY-MM-DD)',
          obscureText: false,
          maxLines: 1,
        ),
        const SizedBox(height: 15),

        Row(
          children: const [
            Text(
              "Location Found:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        MyTextfield(
          controller: locationFoundController,
          hintText: 'Location Found',
          obscureText: false,
          maxLines: 1,
        ),

        Row(
          children: [
            Text(
              "Reference Photo/ID: ${widget.referenceId}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,    
                color: Colors.white,
              ),
            ),
          ],
        ),
        
        if (_selectedImage != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              _selectedImage!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800000),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
            onPressed: _pickImage,
            child: const Text("Upload Photo"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Header(),
      ),
      endDrawer: CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg-hau.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF800000),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select Form Type",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Radio Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: "claim",
                          groupValue: _formType,
                          onChanged: (value) {
                            setState(() {
                              _formType = value!;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                        const Text(
                          "Claim Item",
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(width: 20),

                        Radio<String>(
                          value: "lost",
                          groupValue: _formType,
                          onChanged: (value) {
                            setState(() {
                              _formType = value!;
                            });
                          },
                          activeColor: Colors.white,
                        ),
                        const Text(
                          "Lost Item",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white, thickness: 2),
                    const SizedBox(height: 10),

                    // Show Form Based on Selection
                    _formType == "claim" ? _buildClaimForm() : _buildLostForm(),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF800000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final api = PostService();

                            if (_formType == "claim") {
                              final res = await api.createClaim(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                contact: contactController.text,
                                studentId: studentController.text,
                                referenceId:
                                    widget.referenceId ?? "ref-${DateTime.now().millisecondsSinceEpoch}", 
                                justification: claimController.text,
                                imageFile: _selectedImage,
                              );

                              if (res.statusCode == 200 ||
                                  res.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Claim submitted!")), // For successful claims
                                );
                                resetForm();
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${res.data}")), // For unsuccessful claims
                              );
                            } else {
                              final res = await api.createLostItem(
                                itemName: itemNameController.text,
                                itemCategory: [itemCategoryController.text], 
                                description: descriptionController.text,
                                dateFound: dateFoundController.text,
                                locationFound: locationFoundController.text,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                
                                SnackBar(
                                  content: Text(
                                    "Lost Item Submitted: ${res.data}",
                                  ),
                                ),
                              );
                              resetForm();
                            }
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
