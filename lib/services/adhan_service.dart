import 'package:http/http.dart' as http;
import 'dart:convert';

class AdhanService {
  Future<String?> fetchAdhanUrl() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/adhan?type=makkah'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['adhan_url']; // Sesuaikan dengan struktur respons API
      } else {
        throw Exception('Gagal memuat adhan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 