import 'package:flutter/material.dart';
import 'package:lost_n_haund_client/components/my_button.dart';
import 'package:lost_n_haund_client/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Login Page!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              
              //username
              MyTextfield(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //pass
              MyTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",
                      style: TextStyle(color: Colors.grey[600]),
                    )
                ],
              ),
              ),

              MyButton(
                onTap: () {
                  // Handle sign in logic here
                  print("Sign In Pressed");
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}