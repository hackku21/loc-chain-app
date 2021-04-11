import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:loc_chain_app/util/transaction_manager.dart';

String baseUrl = 'http://loc.glmdev.tech:8000/';

Future<http.Response> postEncounter(EncounterTransaction encounter) async {
  var payload = jsonEncode(encounter);
  var url = Uri.parse('http://loc.glmdev.tech:8000/api/v1/encounter');
  return await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: payload,
  );
}

Future<http.Response> postExposure(ExposureTransaction exposure) async {
  var payload = jsonEncode(exposure);
  var url = Uri.parse('http://loc.glmdev.tech:8000/api/v1/exposure');
  return await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: payload,
  );
}
