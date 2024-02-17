import 'package:flutter/material.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Baak/model/bookingruanganBaak.dart';
import 'package:itdel/Baak/service/bookingruanganBaak_services.dart';

class BookingRuanganBaakView extends StatefulWidget {
  @override
  _BookingRuanganBaakViewState createState() => _BookingRuanganBaakViewState();
}

class _BookingRuanganBaakViewState extends State<BookingRuanganBaakView> {
  late Future<ApiResponse<List<BookingRuanganBaak>>> _bookingData;

  @override
  void initState() {
    super.initState();
    _bookingData = BookingRuanganBaakServices.viewAllBookingsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Ruangan Baak'),
      ),
      body: FutureBuilder<ApiResponse<List<BookingRuanganBaak>>>(
        future: _bookingData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.error != null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            List<BookingRuanganBaak> bookings = snapshot.data!.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                BookingRuanganBaak booking = bookings[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: ListTile(
                    title: Text('Booking ID: ${booking.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room: ${booking.ruangan}'),
                        Text('Reason: ${booking.reason}'),
                        Text('Status: ${booking.status}'),
                        Text('Start Date: ${booking.startDate}'),
                        Text('End Date: ${booking.endDate}'),
                        // Add other widgets as needed
                      ],
                    ),
                    trailing: booking.status == 'approved'
                        ? null
                        : ElevatedButton(
                            onPressed: () => approveBooking(booking.id!),
                            child: Text('Approve'),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void approveBooking(int bookingId) async {
    ApiResponse<String> response =
        await BookingRuanganBaakServices.approveBooking(bookingId);
    processResponse(response);
  }

  void processResponse(ApiResponse<String> response) {
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        // Refresh data after action
        _bookingData = BookingRuanganBaakServices.viewAllBookingsForBaak();
      });
    }
  }
}
