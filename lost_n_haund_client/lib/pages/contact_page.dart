import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';

class ContactUsPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  // text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final messageController = TextEditingController();
  final studentController = TextEditingController();

  ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 75, 
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // Image.asset(
            //   "assets/twiceLogo.jpg", 
            //   height: 40,
            // ),
            const SizedBox(width: 10),
            const Text(
              "HOLY ANGEL\nUNIVERSITY",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF800020)),
            onPressed: () {
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/holy.jpg"), 
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
                      "Contact Us",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // First Name
                    Row(
                      children: [
                        Text(
                          "First Name:",
                          style: TextStyle(
                            fontSize: 18,
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
                    ),
                    const SizedBox(height: 15),

                    // Last Name
                    Row(
                      children: [
                        Text(
                          "Last Name:",
                          style: TextStyle(
                            fontSize: 18,
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
                    ),
                    const SizedBox(height: 15),

                    // Email
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email:',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    // Contact No.
                    Row(
                      children: [
                        Text(
                          "Contact No.",
                          style: TextStyle(
                            fontSize: 18,
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
                    ),
                    const SizedBox(height: 15),

                    // Student No.
                    Row(
                      children: [
                        Text(
                          "Student No.",
                          style: TextStyle(
                            fontSize: 18,
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
                    ),
                    const SizedBox(height: 15),

                    // Message
                    Row(
                      children: [
                        Text(
                          "Message:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    MyTextfield(
                      controller: messageController,
                      hintText: 'Message',
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
