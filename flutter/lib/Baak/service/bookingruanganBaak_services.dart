import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itdel/api_response.dart';
import 'package:itdel/Baak/model/bookingruanganBaak.dart';
import 'package:itdel/global.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';

class BookingRuanganBaakServices {
  static Future<ApiResponse<List<BookingRuanganBaak>>>
      viewAllBookingsForBaak() async {
    ApiResponse<List<BookingRuanganBaak>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'booking-ruangan-all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['BookingRuangan'];
          List<BookingRuanganBaak> bookingList =
              data.map((json) => BookingRuanganBaak.fromJson(json)).toList();
          apiResponse.data = bookingList;
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in viewAllBookingsForBaak: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<String>> approveBooking(int bookingId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(
            baseURL + 'booking-ruangan/$bookingId/approve'), // Adjust as needed
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Booking Request Approved';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in approveBooking: $e");
    }

    return apiResponse;
  }
}
