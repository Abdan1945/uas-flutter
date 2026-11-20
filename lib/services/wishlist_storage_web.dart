import 'dart:js_interop';

@JS('window.localStorage')
external _LocalStorage get _localStorage;

@JS()
extension type _LocalStorage(JSObject _) implements JSObject {
  external JSString? getItem(JSString key);
  external void setItem(JSString key, JSString value);
}

Future<String?> read(String key) async =>
    _localStorage.getItem(key.toJS)?.toDart;

Future<void> write(String key, String value) async {
  _localStorage.setItem(key.toJS, value.toJS);
}
