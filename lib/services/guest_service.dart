import 'dart:convert';
import 'package:http/http.dart' as http;
// Make sure this path points to your guest_model.dart file
import '../models/guest_model.dart';

class GuestService {
  // Use localhost for Chrome. If testing on Android Emulator later, change to 10.0.2.2
static const String baseUrl = "http://localhost:5251/api/Guest";
  // POST: Register Guest
  Future<http.Response> registerGuest(Map<String, dynamic> data) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl/register-guest'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      return http.Response(jsonEncode({"message": "Error: $e"}), 500);
    }
  }

  Future<List<dynamic>> fetchFlaggedGuests() async {
    try {
      // Flagged guests ka naya endpoint
      final response = await http.get(Uri.parse('$baseUrl/flagged-guests'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print("Flagged Fetch Error: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchAllHotels() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Guest/all-registered-hotels'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  }

  Future<List<dynamic>> fetchGuestsByHotel(int hotelId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Guest/hotel-guests/$hotelId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  }

  // guest_service.dart mein add karein
  Future<List<dynamic>> fetchGuestsRaw() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-guests'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Direct List return karein
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // GET: Fetch all guests for Admin Dashboard
  Future<List<Guest>> fetchGuests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-guests'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Guest.fromJson(data)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Fetch Guests Error: $e");
      return [];
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GuestService {
//   // We use the same configuration as your working AuthService
//   // https is required because your Kestrel server is running on port 5251
//     static const String baseUrl = "http://localhost:5251/api/Guest"; 

//   static const String baseUrl = "http://localhost:5251/api/Guest";
//   Future<http.Response> registerGuest(Map<String, dynamic> data) async {
//     try {
//       return await http.post(
//         Uri.parse('$baseUrl/register-guest'),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode(data),
//       );
//     } catch (e) {
//       // This catches connection timeouts or IP mismatches
//       print("GuestService Connection Error: $e");
//       return http.Response(jsonEncode({"message": "Network error: $e"}), 500);
//     }
//   }

  
// }

