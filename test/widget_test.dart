import 'package:flutter_test/flutter_test.dart';
import 'package:daily_fuel_tracker_mobile/app.dart';

void main() {
  testWidgets('Login ekranı başlangıçta görüntülenir', (WidgetTester tester) async {
    // Ana uygulama widget'ı test ortamında başlatılır.
    await tester.pumpWidget(const DailyFuelTrackerApp());

    // Başlangıç ekranındaki giriş başlığı doğrulanır.
    expect(find.text('Hoş Geldin'), findsOneWidget);
  });
}
