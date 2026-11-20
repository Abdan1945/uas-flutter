final Map<String, String> _values = {};

Future<String?> read(String key) async => _values[key];

Future<void> write(String key, String value) async {
  _values[key] = value;
}
