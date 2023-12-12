import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../screens/login_screen.dart'; // Import the login screen

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nimController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _noKtpController = TextEditingController();
  TextEditingController _nomorHandphoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIM';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noKtpController,
                decoration: InputDecoration(labelText: 'No. KTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your No. KTP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorHandphoneController,
                decoration: InputDecoration(labelText: 'Nomor Handphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
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
                    // Call the registerUser method from UserService
                    _userService.registerUser({
                      'nim': _nimController.text,
                      'nama': _namaController.text,
                      'noKtp': _noKtpController.text,
                      'nomorHandphone': _nomorHandphoneController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    }).then(
                      (response) {
                        // Print the response for debugging
                        print(response);

                        // Check if registration is successful
                        if (response['user'] != null &&
                            response['token'] != null) {
                          // Create a User object from the response
                          User registeredUser = User.fromJson(response['user']);

                          // Print the user details for debugging
                          print('Registered user: $registeredUser');

                          // Navigate to the login screen
                          print('Navigating to LoginScreen');
                          Navigator.pop(context); // Go back to the login screen
                        } else {
                          // Handle unsuccessful registration
                          print('Registration failed');
                        }
                      },
                    ).catchError((error) {
                      // Handle registration error
                      print('Registration error: $error');
                    });
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text('Already have an account? Login here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
