import 'dart:convert';

import 'package:cv_flutter_phil/api_service.dart';
import 'package:cv_flutter_phil/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

ApiService _apiService() {
  return ApiService(
    baseUrl: 'http://example.test/public',
    client: MockClient((request) async {
      if (request.url.path.endsWith('/accounts/login')) {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (body['email'] == 'test@example.com' &&
            body['password'] == 'secret123') {
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Connexion réussie',
              'data': {'id': 1, 'email': body['email']},
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Email ou mot de passe incorrect',
          }),
          401,
        );
      }

      if (request.url.path.endsWith('/famille-membres')) {
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'Membres récupérés',
            'data': [
              {
                'id': 1,
                'nom': 'Bauma',
                'postnom': 'M',
                'prenom': 'Aïssatou',
                'lieu_naissance': 'Goma',
                'date_naissance': '1980-01-02',
                'parente': 'Maman',
                'image_url': null,
              },
            ],
          }),
          200,
        );
      }
      return http.Response(
        jsonEncode({'success': false, 'message': 'Route introuvable'}),
        404,
      );
    }),
  );
}

void main() {
  testWidgets('login validates and sends credentials to the API', (
    tester,
  ) async {
    final apiService = _apiService();
    addTearDown(apiService.close);
    await tester.pumpWidget(CvApp(apiService: apiService));

    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.text('Saisissez votre e-mail.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'bad@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrong');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loginError')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret123');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cvPage')), findsOneWidget);
  });

  testWidgets('family and contact pages display their data', (tester) async {
    final apiService = _apiService();
    addTearDown(apiService.close);
    await tester.pumpWidget(CvApp(apiService: apiService));
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret123');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Famille').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('familyPage')), findsOneWidget);
    expect(find.text('Aïssatou M Bauma'), findsOneWidget);
    expect(find.text('Goma · 1980-01-02'), findsOneWidget);

    await tester.tap(find.text('Contact').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('contactPage')), findsOneWidget);
    expect(find.text('evlukoobauma@gmail.com'), findsOneWidget);
    expect(find.text('Goma, RDC'), findsOneWidget);
  });
}
