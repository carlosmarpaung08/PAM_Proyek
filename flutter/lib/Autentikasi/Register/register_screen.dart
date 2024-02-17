import 'package:flutter/material.dart';
import 'package:itdel/Mahasiswa/screen/Mahasiswa_screen.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Autentikasi/Register/register.dart';
import 'package:itdel/Autentikasi/Register/register_services.dart';
import 'package:itdel/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itdel/Autentikasi/Login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController txtname = TextEditingController();
  TextEditingController txtnomorktp = TextEditingController();
  TextEditingController txtnomorhandphone = TextEditingController();
  TextEditingController txtnim = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  createAccountPressed() async {
    ApiResponse response = await register(
      txtname.text,
      txtnomorktp.text,
      txtnomorhandphone.text,
      txtnim.text,
      txtemail.text,
      txtpassword.text,
    );
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MahasiswaScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Enable scrolling
        child: Padding(
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
                        controller: txtname,
                        validator: (val) =>
                            val!.isEmpty ? 'Nama Tidak Boleh Kosong' : null,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          hintText: 'Enter your name',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: txtnim,
                        validator: (val) =>
                            val!.isEmpty ? 'NIM tidak boleh kosong' : null,
                        decoration: InputDecoration(
                          labelText: 'NIM',
                          hintText: 'Enter your NIM',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: txtnomorhandphone,
                        validator: (val) => val!.isEmpty
                            ? 'Nomor Handphone tidak boleh kosong'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Nomor Handphone',
                          hintText: 'Enter your Number Phone',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: txtnomorktp,
                        validator: (val) => val!.isEmpty
                            ? 'Nomor KTP tidak boleh kosong'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Nomor KTP',
                          hintText: 'Enter your Number KTP',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: txtemail,
                        validator: (val) =>
                            val!.isEmpty ? 'Invalid email address' : null,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, // Sesuaikan dengan kebutuhan Anda
                            horizontal: 16.0, // Sesuaikan dengan kebutuhan Anda
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedButton(
                        btnText: 'Register',
                        onBtnPressed: () => createAccountPressed(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Sudah punya akun? Login sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Added bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
