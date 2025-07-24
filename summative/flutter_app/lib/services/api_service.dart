import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://YOUR-RENDER-URL.onrender.com';

  static Future<double?> predictMalaria(Map<String, dynamic> inputData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(inputData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['prediction'];
      } else {
        print('Error: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
