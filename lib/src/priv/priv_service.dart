import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/priv/priv.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class PrivService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  PrivService(this._http);

  Future<List<Priv>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/privs');
      final data = _extractData(response) as List;
      final privs = (data)
          .map((value) => Priv.fromJson(value))
          .toList();
      return privs;
    } catch (e) {
      throw _handleError(e);
    }
  }

 

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/privs/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Priv>());
        return paging;
      }
        

      final privs = (data).map((value) => Priv.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), privs);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/privs/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final privs = (data).map((value) => Priv.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), privs);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Priv> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/priv/$id');
      
      return Priv.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Priv> create(Priv priv) async {
    print(json.encode(priv));
    try {
      final response = await _http.post(
        '$_idmUrl/priv',
        headers: _headers, 
        body: json.encode(priv),
      );
      return Priv.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

   Future<Priv> update(Priv priv) async {
    try {
      final url = '$_idmUrl/priv/${priv.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(priv));
      return Priv.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }


   Future<List<Resource>> getResources() async {
    try {
      final response = await _http.get('$_idmUrl/resources');
      final data = _extractData(response) as List;
      final resources = (data)
          .map((value) => Resource.fromJson(value))
          .toList();
      return resources;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Action>> getActions() async {
    try {
      final response = await _http.get('$_idmUrl/actions');
      final data = _extractData(response) as List;
      final actions = (data)
          .map((value) => Action.fromJson(value))
          .toList();
      return actions;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // List<Priv> mockPrivList = privList().toList();
  // Future<List<Priv>> getPrivList() async => mockPrivList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

// Iterable<Priv> privList() sync* {
//   var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

//   for (var name in names) {
//     var priv = Priv(name: name);
//     yield priv;
//   }
// }