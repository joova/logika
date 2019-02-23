import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/org/org.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class OrgService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  OrgService(this._http);

  Future<List<Org>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/orgs');
      final data = _extractData(response) as List;
      final orgs = (data)
          .map((value) => Org.fromJson(value))
          .toList();
      return orgs;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/orgs/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Org>());
        return paging;
      }
        

      final orgs = (data).map((value) => Org.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), orgs);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/orgs/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final orgs = (data).map((value) => Org.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), orgs);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Org> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/org/$id');
      
      return Org.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Org> create(Org org) async {
    print(json.encode(org));
    try {
      final response = await _http.post(
        '$_idmUrl/org',
        headers: _headers, 
        body: json.encode(org),
      );
      return Org.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Org> update(Org org) async {
    try {
      final url = '$_idmUrl/org/${org.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(org));
      return Org.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<Org> mockOrgList = orgList().toList();
  Future<List<Org>> getOrgList() async => mockOrgList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<Org> orgList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var org = Org(name: name);
    yield org;
  }
}