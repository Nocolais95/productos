import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  // Esto lo sacamos de firebase
  final String _firebaseToken = 'AIzaSyAI00KbgD48VNMQvNhHTNB4kKVX4rxyQgU';

  final storage = FlutterSecureStorage();

  // Si retornamos algo es un error, sino todo bien
  Future<String?> createUser(String email, String password) async {
    // Creamos la informacion del post
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      // Esto lo pide firebase
      'returnSecureToken': true,
    };

    // Creamos el url que vamos a llamar
    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signUp',
      {'key': _firebaseToken},
    );

    // aca realizamos la peticion http y recibimos una respuesta
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Hay que guardar el Token en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // return decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    // Creamos la informacion del post
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      // Esto lo pide firebase
      'returnSecureToken': true,
    };

    // Creamos el url que vamos a llamar
    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signInWithPassword',
      {'key': _firebaseToken},
    );

    // aca realizamos la peticion http y recibimos una respuesta
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Hay que guardar el Token en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // return decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  // Para salir de la app simplemente hay que destruir el token mediante el logout
  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
