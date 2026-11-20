import 'package:flutter_test/flutter_test.dart';
import 'package:uas_abdan_xiirpl3/models/volcano_model.dart';
import 'package:uas_abdan_xiirpl3/services/wishlist_service.dart';

void main() {
  test('toggle adds and removes a volcano from wishlist', () async {
    final wishlist = WishlistService.instance;
    await wishlist.ready;
    final volcano = Volcano(
      nama: 'Gunung Uji',
      bentuk: 'stratovulkan',
      tinggiMeter: '1000 meter',
      estimasiLetusanTerakhir: '2020',
      geolokasi: '1.0°S 100.0°E',
    );
    final wasFavorite = wishlist.contains(volcano);

    expect(await wishlist.toggle(volcano), isNot(wasFavorite));
    expect(await wishlist.toggle(volcano), wasFavorite);
  });
}
