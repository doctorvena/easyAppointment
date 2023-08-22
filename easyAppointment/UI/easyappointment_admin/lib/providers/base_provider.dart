import 'dart:convert';

import 'package:eprodaja_admin/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/search_result.dart';
import '../utils/utils.dart';

class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvider(String endpint) {
    _endpoint = endpint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7198");
  }

  Future<T> getById(dynamic id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<searchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    print("url");
    print(url);

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = searchResult<T>();

      for (var item in data) {
        // TimeSlot t = TimeSlot(timeSlotId, startTime, endTime, businessId, duration)
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    print(request);
    var jsonRequest = jsonEncode(request);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);

    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<void> delete(int id) async {
    var url = '$_baseUrl$_endpoint/$id';
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 204) {
      // Deletion successful, no content to return
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Entity not found');
    } else {
      throw Exception('Unknown error');
    }
  }

  T fromJson(data) {
    throw Exception("Metod not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix: '&', bool inRecursion: false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  Future<LoginResponse> loginUser(String username, String password) async {
    final url =
        Uri.parse('$_baseUrl/Login?username=$username&password=$password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin')),
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final user = fromJson(userData);
      print('Login successful');
      return user;
      // Handle the successful login response here
    } else {
      print('Error logging in: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Login failed');
      // Handle the login error here
    }
  }

  Future createUser(Map<String, dynamic> requestBody) async {
    var url1 = "$_baseUrl$_endpoint/register";
    final url = Uri.parse(url1);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin')),
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('User created successfully');
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      print('Error creating user: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
