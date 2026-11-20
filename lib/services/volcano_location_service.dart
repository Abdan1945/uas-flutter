import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/volcano_model.dart';

class VolcanoLocationService {
  static final Map<String, Future<String?>> _locationCache = {};

  Future<String?> getAdministrativeArea(Volcano volcano) {
    final coordinates = _parseCoordinates(volcano.geolokasi);
    if (coordinates == null) {
      return Future.value(null);
    }

    final cacheKey = '${coordinates.$1},${coordinates.$2}';
    return _locationCache.putIfAbsent(
      cacheKey,
      () => _reverseGeocode(coordinates.$1, coordinates.$2),
    );
  }

  (double, double)? _parseCoordinates(String value) {
    final match = RegExp(
      r'^\s*(\d+(?:\.\d+)?)\s*°?\s*([NS])\s+(\d+(?:\.\d+)?)\s*°?\s*([EW])\s*$',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) {
      return null;
    }

    var latitude = double.parse(match.group(1)!);
    var longitude = double.parse(match.group(3)!);
    if (match.group(2)!.toUpperCase() == 'S') {
      latitude = -latitude;
    }
    if (match.group(4)!.toUpperCase() == 'W') {
      longitude = -longitude;
    }
    return (latitude, longitude);
  }

  Future<String?> _reverseGeocode(double latitude, double longitude) async {
    final response = await http.get(
      Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': '$latitude',
        'lon': '$longitude',
        'zoom': '10',
        'addressdetails': '1',
        'accept-language': 'id',
      }),
      headers: const {
        'User-Agent': 'VolcanoCatalogApp/1.0 (educational Flutter project)',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mencari daerah gunung (Status: ${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      return null;
    }
    final address = data['address'];
    if (address is! Map<String, dynamic>) {
      return null;
    }

    final locality = _firstAddressValue(address, [
      'county',
      'city',
      'municipality',
      'state_district',
      'district',
    ]);
    final province = _firstAddressValue(address, [
      'state',
      'province',
      'region',
    ]);
    if (locality != null && province != null && locality != province) {
      return '$locality, $province';
    }
    return locality ?? province;
  }

  String? _firstAddressValue(Map<String, dynamic> address, List<String> keys) {
    for (final key in keys) {
      final value = address[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
