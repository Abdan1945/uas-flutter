class Volcano {
  final String nama;
  final String bentuk;
  final String tinggiMeter;
  final String estimasiLetusanTerakhir;
  final String geolokasi;

  Volcano({
    required this.nama,
    required this.bentuk,
    required this.tinggiMeter,
    required this.estimasiLetusanTerakhir,
    required this.geolokasi,
  });

  String get id => '${nama.toLowerCase()}|${geolokasi.toLowerCase()}';

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'bentuk': bentuk,
    'tinggi_meter': tinggiMeter,
    'estimasi_letusan_terakhir': estimasiLetusanTerakhir,
    'geolokasi': geolokasi,
  };

  factory Volcano.fromJson(Map<String, dynamic> json) {
    return Volcano(
      nama: json['nama']?.toString() ?? 'Tidak diketahui',
      bentuk: json['bentuk']?.toString() ?? '-',
      tinggiMeter: json['tinggi_meter']?.toString() ?? '-',
      estimasiLetusanTerakhir:
          json['estimasi_letusan_terakhir']?.toString() ?? '-',
      geolokasi: json['geolokasi']?.toString() ?? '-',
    );
  }
}
