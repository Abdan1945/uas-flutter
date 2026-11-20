import 'wishlist_storage_memory.dart'
    if (dart.library.js_interop) 'wishlist_storage_web.dart'
    as platform;

class WishlistStorage {
  Future<String?> read(String key) => platform.read(key);

  Future<void> write(String key, String value) => platform.write(key, value);
}
