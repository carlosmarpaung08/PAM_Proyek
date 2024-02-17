import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itdel/Mahasiswa/model/bookingruangan.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/service/bookingruangan_services.dart';
import 'package:itdel/Mahasiswa/screen/bookingruangan_screen.dart';

class FormBookingRuangan extends StatefulWidget {
  final BookingRuangan? formBookingRuangan;
  final String? title;

  FormBookingRuangan({this.formBookingRuangan, this.title});

  @override
  _FormBookingRuanganState createState() => _FormBookingRuanganState();
}

class _FormBookingRuanganState extends State<FormBookingRuangan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _loading = false;

  String? _selectedRoom;
  List<String> _roomOptions = [
    'GD 5',
    'GD 7',
    'GD 9'
  ]; // Isi dengan pilihan ruangan Anda

  @override
  void initState() {
    super.initState();
    if (widget.formBookingRuangan != null) {
      _selectedRoom = widget.formBookingRuangan!.ruangan ?? '';
      _reasonController.text = widget.formBookingRuangan!.reason ?? '';
      if (widget.formBookingRuangan!.startDate != null) {
        _startDateController.text = DateFormat("yyyy-MM-dd HH:mm")
            .format(widget.formBookingRuangan!.startDate!);
      }
      if (widget.formBookingRuangan!.endDate != null) {
        _endDateController.text = DateFormat("yyyy-MM-dd HH:mm")
            .format(widget.formBookingRuangan!.endDate!);
      }
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute);
        controller.text =
            DateFormat("yyyy-MM-dd HH:mm").format(combinedDateTime);
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    DateTime startDate = DateTime.parse(_startDateController.text);
    DateTime endDate = DateTime.parse(_endDateController.text);
    String ruangan = _selectedRoom!;
    String reason = _reasonController.text;

    ApiResponse response;
    if (widget.formBookingRuangan == null) {
      // Create a new booking
      response =
          await createBookingRuangan(ruangan, reason, startDate, endDate);
    } else {
      // Update an existing booking
      int id = widget.formBookingRuangan!.id ?? 0;
      response =
          await updateBookingRuangan(id, ruangan, reason, startDate, endDate);
    }

    if (response.error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookingRuanganScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error ?? 'Error')));
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Form Booking Ruangan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedRoom,
                  items: _roomOptions.map((String room) {
                    return DropdownMenuItem<String>(
                      value: room,
                      child: Text(room),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRoom = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Ruangan',
                    border: OutlineInputBorder(),
                    // You can customize further with hintText, errorText, etc.
                  ),
                  validator: (value) =>
                      value == null ? 'Please choose a room' : null,
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(labelText: 'Reason'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a reason' : null,
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  onTap: () => _selectDateTime(context, _startDateController),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  onTap: () => _selectDateTime(context, _endDateController),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loading ? null : _submitForm,
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
