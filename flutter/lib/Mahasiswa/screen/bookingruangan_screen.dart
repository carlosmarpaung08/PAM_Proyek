import 'package:flutter/material.dart';
import 'package:itdel/Mahasiswa/model/bookingruangan.dart';
import 'package:itdel/Mahasiswa/service/bookingruangan_services.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/screen/FormBookingRuangan.dart';

class BookingRuanganScreen extends StatefulWidget {
  @override
  _BookingRuanganScreenState createState() => _BookingRuanganScreenState();
}

class _BookingRuanganScreenState extends State<BookingRuanganScreen> {
  List<BookingRuangan> _bookingList = [];
  bool _loading = true;

  Future<void> retrieveBookings() async {
    ApiResponse response = await getBookingRuangan();
    if (response.error == null) {
      setState(() {
        _bookingList = response.data;
        _loading = false;
      });
    } else {
      // Handle errors
    }
  }

  void deleteBooking(int id) async {
    ApiResponse response = await deleteBookingRuangan(id);
    if (response.error == null) {
      retrieveBookings();
    } else {
      // Handle errors
    }
  }

  void navigateToAddBooking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormBookingRuangan(title: 'Add Booking Ruangan'),
      ),
    );
  }

  void navigateToEditBooking(BookingRuangan booking) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormBookingRuangan(
          title: "Edit Booking Ruangan",
          formBookingRuangan: booking,
        ),
      ),
    );
  }

  void viewBookingDetails(BookingRuangan booking) {
    // Implementation for viewing booking details
    // Placeholder for the demonstration
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("View Booking"),
          content: Text("Details for Booking: ${booking.ruangan}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Ruangan'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Ruangan')),
                  DataColumn(label: Text('Reason')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _bookingList.asMap().entries.map(
                  (entry) {
                    int idx = entry.key;
                    BookingRuangan booking = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text('${idx + 1}')),
                        DataCell(Text(booking.ruangan ?? 'N/A')),
                        DataCell(Text(booking.reason ?? 'N/A')),
                        DataCell(Text(booking.status ?? 'N/A')),
                        DataCell(
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
                                PopupMenuItem(
                                  child: Text('View'),
                                  value: 'view',
                                ),
                                PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              switch (value) {
                                case 'edit':
                                  navigateToEditBooking(booking);
                                  break;
                                case 'view':
                                  viewBookingDetails(booking);
                                  break;
                                case 'delete':
                                  deleteBooking(booking.id ?? 0);
                                  break;
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddBooking,
        child: Icon(Icons.add),
      ),
    );
  }
}
