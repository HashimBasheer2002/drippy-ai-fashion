import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {

  static const baseUrl = "http://127.0.0.1:8000/api/outfits";

  Future<List<dynamic>> getCategories() async {

    final response = await http.get(
      Uri.parse("$baseUrl/categories/")
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

}