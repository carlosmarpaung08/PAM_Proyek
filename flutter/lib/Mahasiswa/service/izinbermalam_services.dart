import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/model/izinbermalam.dart';
import 'package:itdel/global.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';

Future<ApiResponse> createIzinBermalam(
    String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'izinbermalam'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'reason': reason,
      'start_date': start_date.toString(),
      'end_date': end_date.toString(),
    });

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

Future<ApiResponse> getIzinBermalam() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'izinbermalam'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            (jsonDecode(response.body)['RequestIzinBermalam'] as List)
                .map((p) => RequestIzinBermalam.fromJson(p))
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
    print("Error in getIzinBermalam: $e");
  }
  return apiResponse;
}

Future<ApiResponse> updateIzinBermalam(
    int id, String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.put(Uri.parse(baseURL + 'izinbermalam/$id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'reason': reason,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
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

Future<ApiResponse> deleteIzinBermalam(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse(baseURL + 'izinbermalam/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}
