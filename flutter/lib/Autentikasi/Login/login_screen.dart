import 'package:flutter/material.dart';
import 'package:itdel/Baak/screen/Baak_screen.dart';
import 'package:itdel/Mahasiswa/screen/Mahasiswa_screen.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Autentikasi/Login/login.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';

import 'package:itdel/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itdel/Autentikasi/Register/register_Screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtemail.text, txtpassword.text);
    if (response.error == null) {
      _saveAndRedirectHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    if (user.role == 'mahasiswa') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MahasiswaScreen()),
        (route) => false,
      );
    } else if (user.role == 'baak') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BaakScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/logo_del.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtemail,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid email address' : null,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: txtpassword,
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Needs at least 6 characters'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedButton(
                      btnText: 'LOG IN',
                      onBtnPressed: () => _loginUser(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Daftar akun",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
