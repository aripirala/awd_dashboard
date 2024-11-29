// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../models/farmer.dart';
import 'mock_api.dart';

// class ApiService {
//   static const String baseUrl = 'YOUR_API_BASE_URL';

//   Future<List<Farmer>> getFarmers() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/farmers'));

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         return jsonData.map((json) => Farmer.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load farmers');
//       }
//     } catch (e) {
//       throw Exception('Error fetching farmers: $e');
//     }
//   }
// }
//

class ApiService {
  final MockApi _mockApi = MockApi();

  Future<List<Farmer>> getFarmers() async {
    try {
      final jsonData = await _mockApi.getFarmers();
      return jsonData.map((json) => Farmer.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching farmers: $e');
      return [];
    }
  }
}
