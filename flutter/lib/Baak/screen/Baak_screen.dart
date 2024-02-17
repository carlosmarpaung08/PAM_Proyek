import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itdel/Autentikasi/Login/login_screen.dart';
import 'package:itdel/Baak/screen/bookingruanganBaak_screen.dart';
import 'package:itdel/Baak/screen/izinkeluarBaak_screen.dart';
import 'package:itdel/Baak/screen/izinbermalamBaak_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itdel/Baak/screen/pemesananKaosBaak_screen.dart';

class BaakScreen extends StatelessWidget {
  const BaakScreen({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BAAK'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    logout(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the menu
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text('Cancel'),
                    ],
                  ),
                ),
              ),
            ],
            icon: Icon(Icons.account_circle), // Icon for profile
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  // Izin Keluar menggunakan CupertinoButton
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Warna bayangan
                          spreadRadius: 2, // Radius penyebaran bayangan
                          blurRadius: 5, // Radius blur bayangan
                          offset: Offset(0, 3), // Offset bayangan
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IzinKeluarBaakView(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.building_2_fill),
                          SizedBox(height: 8),
                          Text('Lihat Request Izin Keluar'),
                        ],
                      ),
                    ),
                  ),

                  // Izin Bermalam menggunakan CupertinoButton
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Warna bayangan
                          spreadRadius: 2, // Radius penyebaran bayangan
                          blurRadius: 5, // Radius blur bayangan
                          offset: Offset(0, 3), // Offset bayangan
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IzinBermalamBaakView(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.moon_fill),
                          SizedBox(height: 8),
                          Text('Lihat Request Izin Bermalam'),
                        ],
                      ),
                    ),
                  ),

                  // Contoh lainnya dengan Container dan CupertinoButton
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestKaosView(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.shopping_cart),
                          SizedBox(height: 8),
                          Text('Lihat Request Pemesanan Kaos'),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingRuanganBaakView(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.calendar),
                          SizedBox(height: 8),
                          Text('Lihat Request Booking Ruangan'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
