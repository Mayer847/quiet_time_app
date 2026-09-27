import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiet_time_app/src/screens/quiet_time_app_screen.dart';
import 'package:quiet_time_app/src/services/readings_service.dart';
import 'package:quiet_time_app/src/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ReadingsService.instance.load();
  });

  testWidgets('shows morning and evening reading cards', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: QuietTimeAppScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Evening'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });

  testWidgets('next button changes the displayed date', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: QuietTimeAppScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final initialTitle = find.text("Today's Readings");
    expect(initialTitle, findsOneWidget);

    await tester.tap(
      find.byTooltip('Next day'),
    );

    await tester.pumpAndSettle();

    expect(
      find.text("Tomorrow's Readings"),
      findsOneWidget,
    );
  });
}
