import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/my_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';
import 'package:lost_n_haund_client/services/post_service.dart';
import 'package:lost_n_haund_client/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => registerPageState();
}


class registerPageState extends State<RegisterPage> {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final contactController = TextEditingController();
    final studentIdController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final PostService postService = PostService();
    bool isLoading = false;

  Future<void> registerUser() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final contact = contactController.text.trim();
    final studentId = studentIdController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await postService.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        studentId: studentId,
        contact: contact,
        password: password,
      );

      if (!mounted) return; 

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully posted!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((response.data is Map ? response.data["error"] : response.data.toString()) ?? "Failed to post")),

        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                      hintText: 'Contact No. (Optional)',
                      obscureText: false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10),

                     // Student/Employee ID
                    MyTextfield(
                      controller: studentIdController,
                      hintText: 'Student/Employee ID',
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
                      onTap: isLoading ? null : registerUser,
                    ),
                    if (isLoading) const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
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
