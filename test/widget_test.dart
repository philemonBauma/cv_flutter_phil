import 'package:cv_flutter_phil/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login validates demo credentials', (tester) async {
    await tester.pumpWidget(const CvApp());

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.text('Saisissez votre identifiant.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('usernameField')), 'wrong');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrong');
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.byKey(const Key('loginError')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('usernameField')), 'demo');
    await tester.enterText(find.byKey(const Key('passwordField')), 'demo123');
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.byKey(const Key('cvPage')), findsOneWidget);
  });

  testWidgets('bottom navigation opens family and contact pages', (
    tester,
  ) async {
    await tester.pumpWidget(const CvApp());
    await tester.enterText(find.byKey(const Key('usernameField')), 'demo');
    await tester.enterText(find.byKey(const Key('passwordField')), 'demo123');
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    await tester.tap(find.text('Famille').last);
    await tester.pump();
    expect(find.byKey(const Key('familyPage')), findsOneWidget);
    expect(find.text('Aïssatou Diallo'), findsOneWidget);

    await tester.tap(find.text('Contact').last);
    await tester.pump();
    expect(find.byKey(const Key('contactPage')), findsOneWidget);
    expect(find.text('nora.diallo@example.com'), findsOneWidget);
  });
}
