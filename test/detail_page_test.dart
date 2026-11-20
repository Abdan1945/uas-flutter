import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uas_abdan_xiirpl3/models/volcano_model.dart';
import 'package:uas_abdan_xiirpl3/pages/detail_page.dart';

void main() {
  testWidgets('detail page describes the volcano using API data', (
    tester,
  ) async {
    final volcano = Volcano(
      nama: 'Weh',
      bentuk: 'stratovulkan',
      tinggiMeter: '617 meter',
      estimasiLetusanTerakhir: 'Pleistosen',
      geolokasi: '-',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    settings: RouteSettings(arguments: volcano),
                    builder: (_) => const DetailPage(),
                  ),
                );
              },
              child: const Text('Buka detail'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka detail'));
    await tester.pumpAndSettle();

    expect(find.text('Tambahkan ke wishlist'), findsOneWidget);
    expect(find.textContaining('Weh merupakan gunung berapi.'), findsOneWidget);
    expect(find.textContaining('Ketinggiannya 617 meter.'), findsOneWidget);
    expect(
      find.textContaining('Catatan letusan terakhir: Pleistosen.'),
      findsOneWidget,
    );
    expect(find.text('Daerah tidak tersedia'), findsOneWidget);
  });
}
