import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/role/role.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class RoleService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  RoleService(this._http);

  Future<List<Role>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/roles');
      final data = _extractData(response) as List;
      final roles = (data)
          .map((value) => Role.fromJson(value))
          .toList();
      return roles;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/roles/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Role>());
        return paging;
      }
        

      final roles = (data).map((value) => Role.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), roles);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/roles/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final roles = (data).map((value) => Role.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), roles);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Role> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/role/$id');
      
      return Role.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Role> create(Role role) async {
    print(json.encode(role));
    try {
      final response = await _http.post(
        '$_idmUrl/role',
        headers: _headers, 
        body: json.encode(role),
      );
      return Role.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Role> update(Role role) async {
    try {
      final url = '$_idmUrl/role/${role.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(role));
      return Role.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<Role> mockRoleList = roleList().toList();
  Future<List<Role>> getRoleList() async => mockRoleList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<Role> roleList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var role = Role(name: name);
    yield role;
  }
}