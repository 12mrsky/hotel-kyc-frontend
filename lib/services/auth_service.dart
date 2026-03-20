import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ✅ For browser use localhost
// ✅ NEW
static const String baseUrl = "https://hotel-kyc-backend.onrender.com/api/Auth";
  // 🔹 REGISTER
  Future<http.Response> register(
      String name, String email, String password, String phone) async {
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
      }),
    );
  }

  // 🔹 LOGIN (FIXED)
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,   //  FIXED (NOT fullName)
        "password": password,
      }),
    );
  }
}