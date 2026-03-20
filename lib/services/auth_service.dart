import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      "https://hotel-kyc-backend.onrender.com/api/Auth";

  // 🔹 REGISTER
  Future<http.Response> register(
      String name, String email, String password, String phone,
      {String role = "Guest"}) async {
    final url = Uri.parse("$baseUrl/register");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password,
        "phoneNumber": phone,
        "role": role, // 🔥 ADD
      }),
    );
  }

  // 🔹 LOGIN
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
  }
}