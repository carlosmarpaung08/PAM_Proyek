import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itdel/Mahasiswa/model/izinbermalam.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/service/izinbermalam_services.dart';
import 'package:itdel/Mahasiswa/screen/Izinbermalam_screen.dart';

class FormIzinBermalams extends StatefulWidget {
  final RequestIzinBermalam? formIzinBermalam;
  final String? title;

  FormIzinBermalams({this.formIzinBermalam, this.title});

  @override
  _FormIzinBermalamState createState() => _FormIzinBermalamState();
}

class _FormIzinBermalamState extends State<FormIzinBermalams> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _departureDateTimeController =
      TextEditingController();
  final TextEditingController _returnDateTimeController =
      TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Jika edit, isi controller dengan data yang ada
    if (widget.formIzinBermalam != null) {
      _reasonController.text = widget.formIzinBermalam!.reason ?? '';
      _departureDateTimeController.text =
          widget.formIzinBermalam!.startDate != null
              ? DateFormat("yyyy-MM-dd HH:mm")
                  .format(widget.formIzinBermalam!.startDate!)
              : '';
      _returnDateTimeController.text = widget.formIzinBermalam!.endDate != null
          ? DateFormat("yyyy-MM-dd HH:mm")
              .format(widget.formIzinBermalam!.endDate!)
          : '';
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      _selectTime(context, controller, picked);
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, DateTime pickedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final DateTime combinedDateTime = DateTime(pickedDate.year,
          pickedDate.month, pickedDate.day, picked.hour, picked.minute);
      final formattedDateTime =
          DateFormat("yyyy-MM-dd HH:mm").format(combinedDateTime);
      controller.text = formattedDateTime;
    }
  }

  void _createOrEditIzinBermalam() {
    DateTime departureDateTime = _departureDateTimeController.text.isNotEmpty
        ? DateTime.parse(_departureDateTimeController.text)
        : DateTime.now();
    DateTime returnDateTime = _returnDateTimeController.text.isNotEmpty
        ? DateTime.parse(_returnDateTimeController.text)
        : DateTime.now();

    // Pengecekan waktu
    bool isFridayAfter17 = departureDateTime.weekday == DateTime.friday &&
        departureDateTime.hour >= 17;
    bool isSaturdayBefore17 = departureDateTime.weekday == DateTime.saturday &&
        departureDateTime.hour < 17;

    if (!(isFridayAfter17 || isSaturdayBefore17)) {
      // Tampilkan alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Request Tidak Dapat Diproses'),
            content: Text(
                'Request Izin Bermalam hanya dapat dilakukan pada hari Jumat setelah jam 17.00 dan hari Sabtu antara jam 08.00 – 17.00.'),
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
      return;
    }

    setState(() {
      _loading = true;
    });
    if (widget.formIzinBermalam == null) {
      _createIzinBermalam();
    } else {
      _editIzinBermalam(widget.formIzinBermalam!.id ?? 0);
    }
  }

  void _createIzinBermalam() async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);

    ApiResponse response = await createIzinBermalam(
        _reasonController.text, departureDateTime, returnDateTime);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => IzinBermalamScreen(),
        ),
      );
    } else {
      _showError(response.error);
    }
  }

  void _editIzinBermalam(int id) async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);

    ApiResponse response = await updateIzinBermalam(
        id, _reasonController.text, departureDateTime, returnDateTime);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => IzinBermalamScreen(),
        ),
      );
    } else {
      _showError(response.error);
    }
  }

  void _showError(String? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Terjadi kesalahan')),
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(labelText: 'Reason'),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _departureDateTimeController,
                      onTap: () =>
                          _selectDate(context, _departureDateTimeController),
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Start Date'),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _returnDateTimeController,
                      onTap: () =>
                          _selectDate(context, _returnDateTimeController),
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'End Date'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _createOrEditIzinBermalam,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
