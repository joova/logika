import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/user/user.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class UserService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  UserService(this._http);

  Future<List<User>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/users');
      final data = _extractData(response) as List;
      final users = (data)
          .map((value) => User.fromJson(value))
          .toList();
      return users;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/users/$off/$lmt');
      
      final data = _extractData(response) as List;
      final users = (data).map((value) => User.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), users);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/users/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final users = (data).map((value) => User.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), users);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/user/$id');
      
      return User.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> create(User user) async {
    print(json.encode(user));
    try {
      final response = await _http.post(
        '$_idmUrl/user',
        headers: _headers, 
        body: json.encode(user),
      );
      return User.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> update(User user) async {
    try {
      final url = '$_idmUrl/user/${user.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(user));
      return User.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<User> mockUserList = userList().toList();
  Future<List<User>> getUserList() async => mockUserList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<User> userList() sync* {
  var usernames = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var username in usernames) {
    var user = User(username: username, password: "rahasia");
    yield user;
  }
}