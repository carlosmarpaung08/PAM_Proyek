import 'package:flutter/material.dart';

class RequestKaosView extends StatefulWidget {
  @override
  _RequestKaosViewState createState() => _RequestKaosViewState();
}

class _RequestKaosViewState extends State<RequestKaosView> {
  List<Map<String, dynamic>> informasiList = [
    {
      'ukuran': 'L',
      'harga': 'Rp 100.000',
      'metode_pembayaran': 'Transfer Bank',
      'status': '', // Menambahkan status sebagai string kosong
      'buttonVisible': true, // Menambahkan status button
    },
    {
      'ukuran': 'M',
      'harga': 'Rp 90.000',
      'metode_pembayaran': 'Cash',
      'pesanan_diapprove': false,
      'status': '', // Menambahkan status sebagai string kosong
      'buttonVisible': true, // Menambahkan status button
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Request Kaos'),
      ),
      body: ListView.builder(
        itemCount: informasiList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ukuran Kaos: ${informasiList[index]['ukuran']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Harga: ${informasiList[index]['harga']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Metode Pembayaran: ${informasiList[index]['metode_pembayaran']}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Visibility(
                  visible: informasiList[index]['buttonVisible'],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Aksi saat tombol "Tolak" ditekan
                          setState(() {
                            informasiList[index]['status'] = 'Pesanan ditolak';
                            informasiList[index]['buttonVisible'] = false;
                          });
                          print('Request ditolak');
                        },
                        child: Text('Tolak'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Aksi saat tombol "Approve" ditekan
                          setState(() {
                            informasiList[index]['status'] =
                                'Pesanan sudah diapprove';
                            informasiList[index]['buttonVisible'] = false;
                          });
                          print('Request diapprove');
                        },
                        child: Text('Approve'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Visibility(
                  visible: !informasiList[index]['buttonVisible'],
                  child: Text(
                    informasiList[index]['status'],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: informasiList[index]['status'] == 'Pesanan ditolak'
                          ? Colors.red // Warna teks merah jika ditolak
                          : informasiList[index]['status'] ==
                                  'Pesanan sudah diapprove'
                              ? Colors.green // Warna teks hijau jika diapprove
                              : Colors.black, // Warna default
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
