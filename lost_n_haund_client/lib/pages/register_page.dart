import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/my_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser() {
    // TODO: Add registration logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg-hau.jpg"), 
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF800020),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Registration Form",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // First Name
                    MyTextfield(
                      controller: firstNameController,
                      hintText: 'First Name',
                      obscureText: false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                    // Last Name
                    MyTextfield(
                      controller: lastNameController,
                      hintText: 'Last Name',
                      obscureText: false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                    // Email
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Hau Email',
                      obscureText: false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                    // Contact
                    MyTextfield(
                      controller: contactController,
                      hintText: 'Student Number',
                      obscureText: false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                    // Password
                    MyTextfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                    // Confirm Password
                    MyTextfield(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20),

                    MyButton(
                      onTap: registerUser,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a member?',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child: const Text(
                            'Login here',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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
