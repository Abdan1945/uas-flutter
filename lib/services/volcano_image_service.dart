import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/volcano_model.dart';

const _fallbackImageUrl =
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80';

const _curatedVolcanoImageUrls = <String, String>{
  'weh': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCePDU7JON-kncp9hPpvH9QDi5hRChY3eWEqOas7N9j5cZohHFz3nzWQk&s=10',
  'seulawah agam':
      'https://picture.triptrus.com/image/2014/05/gunung-selawah-agam-2.jpeg',
  'sinabung': 'https://upload.wikimedia.org/wikipedia/commons/2/20/Erupsi_Gunung_Sinabung_9_Juni_2019_oleh_Muh_Ma%27rufin_Sudibyo.jpg',
  'gunung toba':
      'https://upload.wikimedia.org/wikipedia/commons/b/b1/Toba_zoom.jpg',
  'kerinci': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWoMhhc70suJpVVjaNFUK19Nk0pqumBVS2XpZA0qnZWntdDxDgM8uWHNQ&s=10',
  'krakatau': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/c9/Krakatoa_volcano_-_Krakatau_Vulkan.jpg/960px-Krakatoa_volcano_-_Krakatau_Vulkan.jpg',
  'merapi': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/c/cd/Gunung_Merapi_from_Merbabu.jpg/960px-Gunung_Merapi_from_Merbabu.jpg',
  'semeru': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/e/e3/Mount_Semeru.jpg/960px-Mount_Semeru.jpg',
  'bromo': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/7d/Mount_Bromo_at_sunrise%2C_showing_its_volcanoes_and_Mount_Semeru_%28background%29.jpg/960px-Mount_Bromo_at_sunrise%2C_showing_its_volcanoes_and_Mount_Semeru_%28background%29.jpg',
  'ijen': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/1/16/Sulfur_mining_in_Kawah_Ijen_-_Indonesia_-_20110608.jpg/960px-Sulfur_mining_in_Kawah_Ijen_-_Indonesia_-_20110608.jpg',
  'rinjani': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/8/8e/Gunung_rinjani.jpg/960px-Gunung_rinjani.jpg',
  'tambora': 'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/78/Mount_Tambora_Volcano%2C_Sumbawa_Island%2C_Indonesia.jpg/960px-Mount_Tambora_Volcano%2C_Sumbawa_Island%2C_Indonesia.jpg',
};

const _volcanoImageSearchTerms = <String, String>{
  'weh': 'Weh',
  'seulawah agam': 'Seulawah Agam',
  'peuet sagoe': 'Peuet Sagoe',
  'geureudong': 'Geureudong',
  'kembar': 'Kembar',
  'sibayak': 'Sibayak',
  'sinabung': 'Sinabung',
  'gunung toba': 'Gunung Toba',
  'helatoba-tarutung': 'Helatoba-Tarutung',
  'imun': 'Imun',
  'sibualbuali': 'Sibualbuali',
  'lubukraya': 'Lubukraya',
  'sorikmarapi': 'Sorikmarapi',
  'talakmau': 'Talakmau',
  'sarik-gajah': 'Sarik-Gajah',
  'marapi': 'Marapi',
  'singgalang': 'Singgalang',
  'tandikat': 'Tandikat',
  'sago': 'Sago',
  'talang': 'Talang',
  'kerinci': 'Kerinci',
  'hutapanjang': 'Hutapanjang',
  'sumbing@101.728': 'Mount Sumbing Sumatra',
  'kunyit': 'Kunyit',
  'pendan': 'Pendan',
  'belirang-beriti': 'Belirang-Beriti',
  'bukit daun': 'Bukit Daun',
  'kaba': 'Kaba',
  'dempo': 'Dempo',
  'patah': 'Patah',
  'bukit lumut balai': 'Bukit Lumut Balai',
  'besar': 'Besar',
  'ranau': 'Ranau',
  'sekincau belirang': 'Sekincau Belirang',
  'suoh': 'Suoh',
  'hulubelu': 'Hulubelu',
  'rajabasa': 'Rajabasa',
  'krakatau': 'Krakatau',
  'pulosari': 'Pulosari',
  'karang': 'Karang',
  'kiaraberes-gagak': 'Kiaraberes-Gagak',
  'perbakti': 'Perbakti',
  'salak': 'Salak',
  'gede': 'Gede',
  'patuha': 'Patuha',
  'wayang-windu': 'Wayang-Windu',
  'malabar': 'Malabar',
  'tangkuban perahu': 'Tangkuban Perahu',
  'papandayan': 'Papandayan',
  'kendang': 'Kendang',
  'kamojang': 'Kamojang',
  'guntur': 'Guntur',
  'tampomas': 'Tampomas',
  'galunggung': 'Galunggung',
  'talagabodas': 'Talagabodas',
  'karaha': 'Karaha',
  'ciremai': 'Ciremai',
  'slamet': 'Slamet',
  'dieng': 'Dieng',
  'sindoro': 'Sindoro',
  'sumbing@110.070': 'Mount Sumbing Java',
  'ungaran': 'Ungaran',
  'telomoyo': 'Telomoyo',
  'merbabu': 'Merbabu',
  'merapi': 'Merapi',
  'muria': 'Muria',
  'lawu': 'Lawu',
  'wilis': 'Wilis',
  'kelud': 'Kelud',
  'kawi-butak': 'Kawi-Butak',
  'arjuno-welirang': 'Arjuno-Welirang',
  'penanggungan': 'Penanggungan',
  'malang': 'Malang',
  'semeru': 'Semeru',
  'bromo': 'Bromo',
  'lamongan': 'Lamongan',
  'lurus': 'Lurus',
  'iyang-argapura': 'Iyang-Argapura',
  'raung': 'Raung',
  'ijen': 'Ijen',
  'baluran': 'Baluran',
  'merbuk': 'Merbuk',
  'bratan': 'Bratan',
  'batur': 'Batur',
  'agung': 'Agung',
  'rinjani': 'Rinjani',
  'tambora': 'Tambora',
  'sangeang api': 'Sangeang Api',
  'wai sano': 'Wai Sano',
  'poco leok': 'Poco Leok',
  'ranaka': 'Ranaka',
  'inierie': 'Inierie',
  'inielika': 'Inielika',
  'ebulobo': 'Ebulobo',
  'iya': 'Iya',
  'sukaria': 'Sukaria',
  'ndete napu': 'Ndete Napu',
  'kelimutu': 'Kelimutu',
  'paluweh': 'Paluweh',
  'egon': 'Egon',
  'ilimuda': 'Ilimuda',
  'lewotobi': 'Lewotobi',
  'leroboleng': 'Leroboleng',
  'riang kotang': 'Riang Kotang',
  'iliboleng': 'Iliboleng',
  'lewotolo': 'Lewotolo',
  'ililabalekan': 'Ililabalekan',
  'iliwerung': 'Iliwerung',
  'batu tara': 'Batu Tara',
  'sirung': 'Sirung',
  'yersey': 'Yersey',
  'kaisar tiongkok': 'Kaisar Tiongkok',
  'nieuwerkerk': 'Nieuwerkerk',
  'gunungapi wetar': 'Gunungapi Wetar',
  'wurlali': 'Wurlali',
  'teon': 'Teon',
  'nila': 'Nila',
  'serua': 'Serua',
  'manuk': 'Manuk',
  'banda api': 'Banda Api',
  'colo': 'Colo',
  'ambang': 'Ambang',
  'soputan': 'Soputan',
  'sempu': 'Sempu',
  'tondano': 'Tondano',
  'lokon-empung': 'Lokon-Empung',
  'mahawu': 'Mahawu',
  'klabat': 'Klabat',
  'tongkoko': 'Tongkoko',
  'ruang': 'Ruang',
  'karangetang': 'Karangetang',
  'banua wuhu': 'Banua Wuhu',
  'awu': 'Awu',
  'submarine 1922': 'Submarine 1922',
  'tarakan': 'Tarakan',
  'dukono': 'Dukono',
  'tobaru': 'Tobaru',
  'ibu': 'Ibu',
  'gamkonora': 'Gamkonora',
  'todoko-ranu': 'Todoko-Ranu',
  'jailolo': 'Jailolo',
  'hiri': 'Hiri',
  'gamalama': 'Gamalama',
  'gunung tidore': 'Gunung Tidore',
  'mare': 'Mare',
  'moti': 'Moti',
  'kie besi': 'Kie Besi',
  'tigalalu': 'Tigalalu',
  'amasing': 'Amasing',
  'bibinoi': 'Bibinoi',
};

class VolcanoImageService {
  static final Map<String, Future<String>> _imageCache = {};

  Future<String> getImageUrl(Volcano volcano) {
    final normalizedName = _normalizeName(volcano.nama);
    final cacheKey = '$normalizedName|${volcano.geolokasi}';
    return _imageCache.putIfAbsent(
      cacheKey,
      () => _findImageUrl(volcano, normalizedName),
    );
  }

  Future<String> _findImageUrl(Volcano volcano, String normalizedName) async {
    final curatedImageUrl = _curatedVolcanoImageUrls[normalizedName];
    if (curatedImageUrl != null) {
      return curatedImageUrl;
    }

    final sumbingKey = normalizedName == 'sumbing'
        ? volcano.geolokasi.contains('101.728')
              ? 'sumbing@101.728'
              : 'sumbing@110.070'
        : normalizedName;
    final searchName = _volcanoImageSearchTerms[sumbingKey] ?? volcano.nama;

    final response = await http.get(
      Uri.https('commons.wikimedia.org', '/w/api.php', {
        'action': 'query',
        'generator': 'search',
        'gsrsearch': 'filetype:bitmap "$searchName" volcano Indonesia',
        'gsrnamespace': '6',
        'gsrlimit': '5',
        'prop': 'imageinfo',
        'iiprop': 'url',
        'iiurlwidth': '800',
        'format': 'json',
        'origin': '*',
      }),
      headers: const {
        'User-Agent': 'VolcanoCatalogApp/1.0 (educational Flutter project)',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mencari gambar gunung (Status: ${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);
    if (data is Map<String, dynamic>) {
      final query = data['query'];
      if (query is Map<String, dynamic>) {
        final pages = query['pages'];
        if (pages is Map<String, dynamic>) {
          final matchingPages = pages.values.where((page) {
            if (page is! Map<String, dynamic>) {
              return false;
            }
            final title = page['title'];
            return title is String &&
                _normalizeName(title).contains(normalizedName);
          });
          final results = [
            ...matchingPages,
            ...pages.values.where((page) => !matchingPages.contains(page)),
          ];
          for (final page in results) {
            if (page is Map<String, dynamic>) {
              final imageInfo = page['imageinfo'];
              if (imageInfo is List && imageInfo.isNotEmpty) {
                final image = imageInfo.first;
                if (image is Map<String, dynamic> &&
                    image['thumburl'] is String) {
                  return image['thumburl'] as String;
                }
              }
            }
          }
        }
      }
    }

    return _fallbackImageUrl;
  }

  String _normalizeName(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}
