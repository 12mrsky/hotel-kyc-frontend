import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guest_model.dart';

class GuestService {
  static const String baseUrl =
      "https://hotel-kyc-backend.onrender.com/api/Guest";

  // ✅ Register Guest
  Future<http.Response> registerGuest(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$baseUrl/register-guest'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  // ✅ Fetch ALL Guests (Admin - typed model)
  Future<List<Guest>> fetchGuests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-guests'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => Guest.fromJson(e)).toList();
      } else {
        print("API Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  // ✅ 🔥 RAW LIST (FIX for your error)
  Future<List<dynamic>> fetchGuestsRaw() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-guests'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("API Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  // ✅ 🔥 FLAGGED GUESTS (FIX for your error)
  Future<List<dynamic>> fetchFlaggedGuests() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/flagged-guests'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("API Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  // ✅ Fetch Hotels
  Future<List<dynamic>> fetchAllHotels() async {
    final response = await http.get(
      Uri.parse('$baseUrl/all-registered-hotels'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  }

  // ✅ Fetch Guests by Hotel
  Future<List<Guest>> fetchGuestsByHotel(int hotelId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/hotel-guests/$hotelId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Guest.fromJson(e)).toList();
    }
    return [];
  }
}