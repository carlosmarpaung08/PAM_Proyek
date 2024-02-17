import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/model/bookingruangan.dart';
import 'package:itdel/global.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';

Future<ApiResponse> createBookingRuangan(
    String ruangan, String reason, DateTime startDate, DateTime endDate) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL + 'booking-ruangan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'ruangan': ruangan,
        'reason': reason,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

Future<ApiResponse> getBookingRuangan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + 'booking-ruangan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['BookingRuangan'] as List)
            .map((p) => BookingRuangan.fromJson(p))
            .toList();
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print("Server Response: ${response.body}");
        break;
    }
  } catch (e) {
    apiResponse.error = 'server error';
    print("Error in getBookingRuangan: $e");
  }
  return apiResponse;
}

Future<ApiResponse> updateBookingRuangan(int id, String ruangan, String reason,
    DateTime startDate, DateTime endDate) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(baseURL + 'booking-ruangan/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'ruangan': ruangan,
        'reason': reason,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> deleteBookingRuangan(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
      Uri.parse(baseURL + 'booking-ruangan/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = 'Forbidden';
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}
