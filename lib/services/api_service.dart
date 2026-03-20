import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Update this to your API URL
//static const String baseUrl = "http://localhost:5251/api/Auth";
const BASE_URL = "https://hotel-kyc-backend.onrender.com/api";
  Future<http.Response> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": name,
        "email": email,
        "password": password, // Must match your C# RegisterRequest property
        "phoneNumber": phone,
      }),
    );
  }

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}
