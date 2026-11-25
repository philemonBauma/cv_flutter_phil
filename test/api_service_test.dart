import 'dart:convert';

import 'package:cv_flutter_phil/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('family CRUD uses the API routes and JSON contract', () async {
    final requests = <http.Request>[];
    final service = ApiService(
      baseUrl: 'http://example.test/api',
      client: MockClient((request) async {
        requests.add(request);
        final statusCode = request.method == 'POST' ? 201 : 200;
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'OK',
            'data': request.method == 'GET' ? [] : {},
          }),
          statusCode,
        );
      }),
    );
    addTearDown(service.close);

    await service.getFamilyMembers();
    const draft = FamilyMemberDraft(
      nom: 'Baraka',
      postnom: 'Bigega',
      prenom: 'Papa',
      lieuNaissance: 'Goma',
      dateNaissance: '1970-05-12',
      parente: 'Père',
    );
    await service.createFamilyMember(draft);
    await service.updateFamilyMember(4, draft);
    await service.deleteFamilyMember(4);

    expect(requests.map((request) => '${request.method} ${request.url.path}'), [
      'GET /api/famille-membres',
      'POST /api/famille-membres',
      'PUT /api/famille-membres/4',
      'DELETE /api/famille-membres/4',
    ]);
    expect(jsonDecode(requests[1].body), draft.toJson());
    expect(requests[2].headers['Content-Type'], 'application/json');
  });

  test('API errors are surfaced to callers', () async {
    final service = ApiService(
      baseUrl: 'http://example.test/api',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'success': false,
            'message': 'Données invalides',
            'errors': {'nom': 'Le champ nom est obligatoire'},
          }),
          422,
        ),
      ),
    );
    addTearDown(service.close);

    await expectLater(
      service.getFamilyMembers(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          contains('Données invalides'),
        ),
      ),
    );
  });
}
