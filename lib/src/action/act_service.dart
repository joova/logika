import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/action/act.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class ActService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  ActService(this._http);

  Future<List<Act>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/actions');
      final data = _extractData(response) as List;
      final acts = (data)
          .map((value) => Act.fromJson(value))
          .toList();
      return acts;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/actions/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Act>());
        return paging;
      }
        

      final acts = (data).map((value) => Act.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), acts);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/actions/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final acts = (data).map((value) => Act.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), acts);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Act> get(String code) async {
    try {
      final response = await _http.get('$_idmUrl/action/$code');
      
      return Act.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Act> create(Act act) async {
    print(json.encode(act));
    try {
      final response = await _http.post(
        '$_idmUrl/action',
        headers: _headers, 
        body: json.encode(act),
      );
      return Act.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Act> update(Act act) async {
    try {
      final url = '$_idmUrl/action/${act.code}';
      final response = await _http.put(url, headers: _headers, body: json.encode(act));
      return Act.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(Act plm_category) async {
    try {
      final url = '$_idmUrl/act/${plm_category.code}';
      final response = await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<Act> mockActList = actList().toList();
  Future<List<Act>> getActList() async => mockActList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<Act> actList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var act = Act(name: name);
    yield act;
  }
}