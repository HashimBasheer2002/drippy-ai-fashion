
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DripService {

  static const String baseUrl = "http://127.0.0.1:8000/api/drips";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  /// UPLOAD DRIP IMAGE
  Future<int?> uploadDrip(XFile image) async {

    final token = await storage.read(key: "access_token");

    if (token == null) {
      print("JWT token not found");
      return null;
    }

    final uri = Uri.parse("$baseUrl/upload/");
    final request = http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = "Bearer $token";

    if (kIsWeb) {

      final bytes = await image.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename: image.name,
        ),
      );

    } else {

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          image.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {

      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      return data["id"];
    }

    print("Upload failed: ${response.statusCode}");
    return null;
  }

  /// FETCH SINGLE DRIP (AI RESULT)
  Future<Map<String, dynamic>?> getDrip(int id) async {

    final token = await storage.read(key: "access_token");

    final response = await http.get(
      Uri.parse("$baseUrl/$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    print("Failed to load drip");
    return null;
  }
}
