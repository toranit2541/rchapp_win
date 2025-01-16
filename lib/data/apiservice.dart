import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

// This is function class API service use for send method (get,put,puse,post,delete) to API service
class ApiService {
  // baseUrl is Web API service URL back-end
  final String baseUrl = "http://192.168.10.249:8000/";

  // set storage is internal storage to save VIP values (token, id card, etc.)
  final storage = const FlutterSecureStorage();

  //function headder
  // Helper method for making HTTP GET requests
  Future<dynamic> _get(String url) async {
    String? token = await getAccessToken();
    if (token == null) throw Exception("Token not found. Please login again.");

    final uri = Uri.parse(baseUrl+url);
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      _checkHttpResponse(response);

      // Decode and return the response body
      return json.decode(utf8.decode(response.bodyBytes));
    } catch (e) {
      print("Error during GET request to $url: $e");
      throw Exception("GET request failed for $url: $e");
    }
  }

  //future function register use to register to system
  Future<void> registerUser(Map<String, dynamic> data) async {
    //set url redirect to path auth/register/ for use class register in WEB API back-end
    final url = Uri.parse('${baseUrl}auth/register/');

    //set resopne to manage json to set values for send method post
    final response = await http.post(
      //url is web api to send
      url,

      // header is function in web api reques
      headers: {'Content-Type': 'application/json'},

      // body is values of user key data input to register form
      body: json.encode(data),
    );

    //function show status code
    _checkHttpResponse(response);
  }

  //future finction login for login access to system
  Future<Map<String, dynamic>> loginUser(Map<String, dynamic> data) async {
    //function try use to check if not error to do it
    try {
      //set url redirect to path auth/login/ for use class register in WEB API back-end
      final url = Uri.parse('${baseUrl}auth/login/');

      //set resopne to manage json to set values for send method post
      final response = await http
          .post(
        //url is web api to send
        url,

        // header is function in web api reques
        headers: {'Content-Type': 'application/json'},

        // body is values of user key data input to register form
        body: json.encode(data),
      )
          //.time out is function count time to use connect to API Service
          .timeout(const Duration(seconds: 10), onTimeout: () {
        //if can not connect on time thne throw error 'time out'
        throw Exception('Request timed out.');
      });

      //if variable response have stutscode is 200
      if (response.statusCode == 200) {
        //set variable responseBody is json values use decode data from API
        final responseBody = json.decode(response.body);

        //check access and refrash
        if (responseBody.containsKey('access') &&
            responseBody.containsKey('refresh')) {
          //after login api out put access token must to save this beacouse use identity to get data
          await saveAccessToken(responseBody['access']);

          //after login api out put refresh token must to save this becouse use clean access in system
          await saveRefreshToken(responseBody['refresh']);

          //return status code and data
          return {'success': true, 'data': responseBody};
        } else {
          //show error
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        //set errorBody is decode of json.body
        final errorBody = json.decode(response.body);

        //set errorMessage is error detail
        final errorMessage = errorBody['detail'] ?? 'Login failed.';

        //show error
        throw Exception('Login failed: $errorMessage');
      }
    } catch (e) {
      //show error
      throw Exception('An error occurred during login: $e');
    }
  }

  //future finction logout for logout access to system
  Future<void> logout(BuildContext context) async {
    try {
      // Retrieve stored tokens
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();

      // If tokens are missing, clear any partial data and don't navigate
      if (accessToken == null || refreshToken == null) {
        debugPrint("No valid tokens found.");
        await clearTokens(); // Clear tokens
        return; // Do not navigate here
      }

      // Prepare logout API request
      final url = Uri.parse('${baseUrl}auth/logout/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refresh': refreshToken}),
      );

      // Evaluate response status codes
      if (response.statusCode == 200 || response.statusCode == 205) {
        debugPrint("Logout successful.");
      } else {
        debugPrint("Logout failed: ${response.statusCode} - ${response.body}");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Logout failed. Please try again.")),
        // );
      }

      // Clear tokens after logout attempt
      await clearTokens();
    } catch (e) {
      // Handle unexpected errors
      debugPrint("Unexpected error during logout: $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("An error occurred. Please try again.")),
      // );

      // Clear tokens as a precaution
      await clearTokens();
    }
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    String? token = await getAccessToken();
    if (token == null) throw Exception("Token not found. Please login again.");

    final url = Uri.parse('${baseUrl}auth/userprofiles/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    _checkHttpResponse(response);

    // Decode the response and handle the list format
    final List<dynamic> decodedBody = json.decode(response.body);
    if (decodedBody.isNotEmpty && decodedBody.first is Map<String, dynamic>) {
      return decodedBody.first as Map<String, dynamic>;
    } else {
      throw Exception("Unexpected response format: ${decodedBody.runtimeType}");
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  // Token Management
  Future<void> saveAccessToken(String token) async {
    await storage.write(key: 'access', value: token);
  }

  Future<String?> getAccessToken() async {
    final token = await storage.read(key: 'access');
    print("Access Token: $token"); // Log the token to verify it
    return token;
  }

  Future<void> clearAccessToken() async {
    await storage.delete(key: 'access');
  }

  // Token Management
  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: 'refresh', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh');
  }

  Future<void> clearRefreshToken() async {
    await storage.delete(key: 'refresh');
  }

  // Error Checking
  void _checkHttpResponse(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(
          'HTTP Error: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<dynamic>> getLabResults() async {
    final url = Uri.parse('${baseUrl}rchdata/lab-results/');
    String? token = await getAccessToken();

    // Fetch citizen ID from profile data
    final Map<String, dynamic> profileData = await fetchProfileData();
    String? citizenId = profileData["username"]; // Access the 'username' field

    if (token == null) {
      throw Exception("Token not found. Please login again.");
    }
    if (citizenId == null) {
      throw Exception(
          "Citizen ID not found. Please ensure your profile is complete.");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authentication token
        },
        body: jsonEncode({
          'citizen_id': citizenId,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

        // Check if the response is a list
        if (decodedBody is List<dynamic>) {
          return decodedBody; // Return the list as is
        } else if (decodedBody is Map<String, dynamic>) {
          throw Exception(
              'Unexpected object format: ${decodedBody.runtimeType}');
        } else {
          throw Exception(
              'Unexpected response format: ${decodedBody.runtimeType}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${jsonDecode(response.body)['error']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials.');
      } else {
        throw Exception('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching lab results: $e');
      throw Exception('Failed to fetch lab results: $e');
    }
  }

  Future<List<dynamic>> getLabResultsAll() async {
    final url = Uri.parse('${baseUrl}rchdata/lab-results-dynamic/');
    String? token = await getAccessToken();

    // Fetch citizen ID from profile data
    final Map<String, dynamic> profileData = await fetchProfileData();
    String? citizenId = profileData["username"]; // Access the 'username' field

    if (token == null) {
      throw Exception("Token not found. Please login again.");
    }
    if (citizenId == null) {
      throw Exception(
          "Citizen ID not found. Please ensure your profile is complete.");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authentication token
        },
        body: jsonEncode({
          'citizen_id': citizenId,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

        // Check if the response is a list
        if (decodedBody is List<dynamic>) {
          return decodedBody; // Return the list as is
        } else if (decodedBody is Map<String, dynamic>) {
          throw Exception(
              'Unexpected object format: ${decodedBody.runtimeType}');
        } else {
          throw Exception(
              'Unexpected response format: ${decodedBody.runtimeType}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${jsonDecode(response.body)['error']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your credentials.');
      } else {
        throw Exception('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching lab results: $e');
      throw Exception('Failed to fetch lab results: $e');
    }
  }

  // Future<List<dynamic>> getPackage() async {
  //   final response = await _get('packages/package/');
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception(
  //         'Failed to load package. Status code: ${response.statusCode}, Message: ${response.body}');
  //   }
  // }

  Future<List<dynamic>> getPackage() async {
    final response = await _get('packages/package/');
    if (response is List<dynamic>){
      return response;
    } else {
      throw Exception(
          'Failed to load package. Status code: ${response
              .statusCode}, Message: ${response.body}'
      );
    }
  }

  Future<List<dynamic>> getArticle() async {
    final response = await _get('articles/article/');
    if (response is List<dynamic>) {
      return response;
    } else {
      throw Exception(
          'Failed to load article. Status code: ${response.statusCode}, Message: ${response.body}');
    }
  }

  Future<List<dynamic>> getNews() async {
    final response = await _get('newses/news/');
    if (response is List<dynamic>) {
      return response;
    } else {
      throw Exception(
          'Failed to load news. Status code: ${response.statusCode}, Message: ${response.body}');
    }
  }

  Future<List<dynamic>> getPopulation() async {
    final response = await _get('populations/population/');
    // Check if the response is a List<dynamic>
    if (response is List<dynamic> ) {
      return response; // Return the list as is
    } else {
      throw Exception(
          'Unexpected response format: Expected List<dynamic>, but got ${response.runtimeType}');
    }
  }

  Future<List<dynamic>> getPromotion() async {
    final response = await _get('promotions/promotion/');
    if (response is List<dynamic>) {
      return response;
    } else {
      throw Exception(
          'Failed to load promotion. Status code: ${response.statusCode}, Message: ${response.body}');
    }
  }
}
