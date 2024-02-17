import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pembelian Kaos',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: KaosOrderScreen(),
    );
  }
}

class KaosOrderScreen extends StatefulWidget {
  @override
  _KaosOrderScreenState createState() => _KaosOrderScreenState();
}

class _KaosOrderScreenState extends State<KaosOrderScreen> {
  String selectedSize = '';
  double totalPrice = 0.0;
  TextEditingController paymentController = TextEditingController();
  String selectedPayment = '';

  Map<String, double> sizePrices = {
    'S': 1000.0,
    'M': 1000.0,
    'L': 1000.0,
    'XL': 1000.0,
    'XXL': 1000.0,
  };

  Map<String, String> paymentOptions = {
    'BankTransfer': 'Transfer Bank',
    'Cash': 'Cash',
  };

  String bankAccountName = 'Indah Sitorus';
  String bankAccountNumber = '1122334455';

  void updateTotalPrice() {
    setState(() {
      totalPrice = sizePrices[selectedSize]!;
    });
  }

  void processPayment() {
    double paymentAmount = double.tryParse(paymentController.text) ?? 0.0;
    if (paymentAmount == totalPrice) {
      // Pembayaran berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pembayaran Berhasil'),
            content: Text('Terima kasih! Pemesanan Anda berhasil.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Pembayaran tidak sesuai
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pembayaran Gagal'),
            content: Text('Jumlah pembayaran tidak sesuai dengan total harga.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void cancelOrder() {
    setState(() {
      selectedSize = '';
      totalPrice = 0.0;
      selectedPayment = '';
      paymentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembelian Kaos'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Ukuran Kaos:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Row(
              children: sizePrices.keys
                  .map(
                    (size) => ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedSize = size;
                        });
                        updateTotalPrice();
                      },
                      style: ButtonStyle(
                        backgroundColor: selectedSize == size
                            ? MaterialStateProperty.all(Colors.yellow)
                            : null,
                      ),
                      child: Text(size),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Harga: \Rp${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Pilih Metode Pembayaran:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: paymentOptions.keys
                  .map(
                    (payment) => ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPayment = payment;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: selectedPayment == payment
                            ? MaterialStateProperty.all(Colors.yellow)
                            : null,
                      ),
                      child: Text(paymentOptions[payment]!),
                    ),
                  )
                  .toList(),
            ),
            if (selectedPayment == 'BankTransfer') ...[
              SizedBox(height: 20.0),
              Text(
                'Pembayaran:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'Silahkan transfer ke rekening:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Nama                   : $bankAccountName',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Nomor Rekening: $bankAccountNumber',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Simpan bukti pembayaran dan tunjukkan bukti pembayaran tersebut kepada staff BAAK ketika Anda mengambil kaos yang telah anda pesan',
                style: TextStyle(fontSize: 16.0),
              ),
            ] else if (selectedPayment == 'Cash') ...[
              SizedBox(height: 20.0),
              Text(
                'Pembayaran:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'Silahkan bayar cash dengan jumlah yang tertera ketika Anda mengambil kaos yang telah anda pesan ke kantor BAAK',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
            SizedBox(height: 20.0),
            TextField(
              controller: paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Pembayaran',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cancelOrder();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedSize.isNotEmpty &&
                        totalPrice > 0 &&
                        selectedPayment.isNotEmpty) {
                      processPayment();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Pilih Ukuran dan Pembayaran'),
                            content: Text(
                                'Pilih ukuran kaos dan metode pembayaran terlebih dahulu.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Bayar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
