import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uas_abdan_xiirpl3/widgets/mountain_loading_view.dart';

void main() {
  testWidgets('shows themed mountain loading state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MountainLoadingView(message: 'Memuat data gunung...'),
        ),
      ),
    );

    expect(find.text('NUSANTARA'), findsOneWidget);
    expect(find.text('Memuat data gunung...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
