import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const _defaultApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost/api-test-main/public',
);

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse('${json['id']}');
    if (id == null) {
      throw const ApiException(
        'La réponse du serveur contient un membre invalide.',
      );
    }

    return FamilyMember(
      id: id,
      nom: _requiredString(json, 'nom'),
      postnom: _requiredString(json, 'postnom'),
      prenom: _requiredString(json, 'prenom'),
      lieuNaissance: _requiredString(json, 'lieu_naissance'),
      dateNaissance: _requiredString(json, 'date_naissance'),
      parente: _requiredString(json, 'parente'),
      imageUrl: json['image_url'] as String?,
    );
  }

  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  String get fullName => '$prenom $postnom $nom';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw ApiException(
        'La réponse du serveur ne contient pas le champ $key.',
      );
    }
    return value;
  }
}

class FamilyMemberDraft {
  const FamilyMemberDraft({
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
  });

  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;

  Map<String, String> toJson() => {
    'nom': nom,
    'postnom': postnom,
    'prenom': prenom,
    'lieu_naissance': lieuNaissance,
    'date_naissance': dateNaissance,
    'parente': parente,
  };
}

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = (baseUrl ?? _defaultApiBaseUrl).replaceFirst(
        RegExp(r'/$'),
        '',
      );

  final http.Client _client;
  final String _baseUrl;

  void close() => _client.close();

  Future<void> login({required String email, required String password}) async {
    await _request(
      'POST',
      '/accounts/login',
      body: {'email': email, 'password': password},
    );
  }

  Future<List<FamilyMember>> getFamilyMembers() async {
    final data = await _request('GET', '/famille-membres');
    if (data is! List) {
      throw const ApiException('La liste des membres reçue est invalide.');
    }

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ApiException(
          'La réponse du serveur contient un membre invalide.',
        );
      }
      return FamilyMember.fromJson(item);
    }).toList();
  }

  Future<void> createFamilyMember(FamilyMemberDraft member) async {
    await _request('POST', '/famille-membres', body: member.toJson());
  }

  Future<void> updateFamilyMember(int id, FamilyMemberDraft member) async {
    await _request('PUT', '/famille-membres/$id', body: member.toJson());
  }

  Future<void> deleteFamilyMember(int id) async {
    await _request('DELETE', '/famille-membres/$id');
  }

  Future<Object?> _request(
    String method,
    String path, {
    Map<String, String>? body,
  }) async {
    final request = http.Request(method, Uri.parse('$_baseUrl$path'))
      ..headers['Accept'] = 'application/json';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    late final http.Response response;
    try {
      response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException('Le serveur ne répond pas. Réessayez.');
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre le serveur. Vérifiez son adresse et votre connexion.',
      );
    }

    late final Map<String, dynamic> envelope;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }
      envelope = decoded;
    } on FormatException {
      throw const ApiException('Le serveur a renvoyé une réponse invalide.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        envelope['success'] != true) {
      final message = envelope['message'];
      final errors = envelope['errors'];
      final details = errors is Map
          ? errors.values.whereType<String>().join(' ')
          : '';
      throw ApiException(
        [
          if (message is String && message.isNotEmpty)
            message
          else
            'Échec de la requête (${response.statusCode}).',
          if (details.isNotEmpty) details,
        ].join(' '),
      );
    }

    return envelope['data'];
  }
}
