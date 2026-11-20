import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/volcano_model.dart';
import 'wishlist_storage.dart';

class WishlistService extends ChangeNotifier {
  WishlistService._() {
    _ready = _load();
  }

  static final WishlistService instance = WishlistService._();
  static const _storageKey = 'saved_volcanoes';
  static final _storage = WishlistStorage();

  late final Future<void> _ready;
  final List<Volcano> _items = [];

  Future<void> get ready => _ready;

  List<Volcano> get items => List.unmodifiable(_items);

  bool contains(Volcano volcano) => _items.any((item) => item.id == volcano.id);

  Future<bool> toggle(Volcano volcano) async {
    await _ready;
    final previousItems = List<Volcano>.of(_items);
    if (contains(volcano)) {
      _items.removeWhere((item) => item.id == volcano.id);
    } else {
      _items.add(volcano);
    }

    try {
      await _save();
    } on Exception {
      _items
        ..clear()
        ..addAll(previousItems);
      rethrow;
    }

    notifyListeners();
    return contains(volcano);
  }

  Future<void> _load() async {
    final savedItems = await _storage.read(_storageKey);
    if (savedItems == null) {
      return;
    }

    final decoded = jsonDecode(savedItems);
    if (decoded is! List) {
      throw const FormatException('Format wishlist tidak valid.');
    }

    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Data gunung di wishlist tidak valid.');
      }
      _items.add(Volcano.fromJson(item));
    }
    notifyListeners();
  }

  Future<void> _save() async {
    await _storage.write(
      _storageKey,
      jsonEncode(_items.map((volcano) => volcano.toJson()).toList()),
    );
  }
}
