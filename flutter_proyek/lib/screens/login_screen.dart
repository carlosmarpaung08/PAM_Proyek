import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screen_mahasiswa/mahasiswa_screen.dart';
import '../screens/register_screen.dart'; // Import the register screen
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Call the loginUser method from UserService
                    _userService
                        .loginUser(
                      _emailController.text,
                      _passwordController.text,
                    )
                        .then(
                      (response) {
                        // Print the response for debugging
                        print(response);

                        // Check if login is successful
                        if (response['user'] != null &&
                            response['token'] != null) {
                          // Create a User object from the response
                          User loggedInUser = User.fromJson(response['user']);

                          // Print the user details for debugging
                          print('Logged in user: $loggedInUser');

                          // Navigate to MahasiswaScreen and pass the logged-in user
                          print('Navigating to MahasiswaScreen');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MahasiswaScreen(user: loggedInUser),
                            ),
                          );
                        } else {
                          // Handle unsuccessful login
                          print('Login failed');
                        }
                      },
                    ).catchError((error) {
                      // Handle login error
                      print('Login error: $error');
                    });
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to the register screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
