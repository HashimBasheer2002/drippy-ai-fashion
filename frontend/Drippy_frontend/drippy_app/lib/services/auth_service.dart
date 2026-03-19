
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const String baseUrl = "http://127.0.0.1:8000/api/accounts";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  /// LOGIN USER
  Future<bool> login(String username, String password) async {

    final url = Uri.parse("$baseUrl/login/");

    try {

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "username": username,
          "password": password
        }),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        final access = data["access"];
        final refresh = data["refresh"];

        await storage.write(key: "access_token", value: access);
        await storage.write(key: "refresh_token", value: refresh);

        return true;
      }

      return false;

    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  /// REGISTER USER
  Future<bool> register(
    String username,
    String email,
    String password,
  ) async {

    final url = Uri.parse("$baseUrl/register/");

    try {

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password
        }),
      );

      return response.statusCode == 201;

    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  /// GET ACCESS TOKEN
  Future<String?> getAccessToken() async {
    return await storage.read(key: "access_token");
  }

  /// LOGOUT
  Future<void> logout() async {
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
  }
}

