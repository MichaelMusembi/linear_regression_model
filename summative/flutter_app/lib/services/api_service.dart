import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Deployed API base URL on Render
  static const String baseUrl =
      'https://linear-regression-model-qjrd.onrender.com';

  /// Predict malaria using the deployed model
  static Future<double?> predictMalaria(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("✅ Prediction result: ${result['prediction']}");
        return result['prediction']?.toDouble();
      } else {
        print(
            "❌ Failed to get prediction. Status code: ${response.statusCode}");
        print("❗ Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception during API call: $e");
      return null;
    }
  }

  /// Check connection to the API root URL
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      if (response.statusCode == 200) {
        print("✅ Connected to API successfully.");
        return true;
      } else {
        print("❌ Connection failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🚨 Connection test exception: $e");
      return false;
    }
  }
}
