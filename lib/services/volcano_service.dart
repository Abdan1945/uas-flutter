import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/volcano_model.dart';

class VolcanoService {
  Future<List<Volcano>> fetchVolcanoes() async {
    try {
      final response = await http.get(Uri.parse(ApiConstant.fullVolcanoesUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Volcano.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}