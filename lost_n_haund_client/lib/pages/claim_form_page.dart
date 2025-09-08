import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_n_haund_client/components/header.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';

class ClaimForm extends StatefulWidget {
  const ClaimForm({super.key});

  @override
  State<ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final studentController = TextEditingController();
  final claimController = TextEditingController();

  File? _selectedImage; // store selected image
  final ImagePicker _picker = ImagePicker();

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photo Uploaded!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75), child: Header()),
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
                      "Claim Form",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white, thickness: 2),

                    // First Name
                    Row(
                      children: const [
                        Text("First Name:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                        Text("Last Name:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                        Text("Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email:',
                      obscureText: false,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 15),

                    // Contact No.
                    Row(
                      children: const [
                        Text("Contact No.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                        Text("Student No.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                      children: const [
                        Text("Reference ID:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
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
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
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
                        Text("Claim Justification:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    MyTextfield(
                      controller: claimController,
                      hintText: 'Insert Claim here',
                      maxLines: 5,
                    ),
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
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Form Submitted!")),
                            );
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
