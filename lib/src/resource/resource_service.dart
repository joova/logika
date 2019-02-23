import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/resource/resource.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class ResourceService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8000/api/idm'; // URL to web API
  final Client _http;
  
  ResourceService(this._http);

  Future<List<Resource>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/resource');
      final data = _extractData(response) as List;
      final resources = (data)
          .map((value) => Resource.fromJson(value))
          .toList();
      return resources;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/resources/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Resource>());
        return paging;
      }
        

      final orgs = (data).map((value) => Resource.fromJson(value)).toList();
      
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
      final response = await _http.get('$_idmUrl/resources/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final orgs = (data).map((value) => Resource.fromJson(value)).toList();
      
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

  Future<Resource> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/resource/$id');
      
      return Resource.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Resource> create(Resource resource) async {
    print(json.encode(resource));
    try {
      final response = await _http.post(
        '$_idmUrl/resource',
        headers: _headers, 
        body: json.encode(resource),
      );
      return Resource.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Resource> update(Resource resource) async {
    try {
      final url = '$_idmUrl/resource/${resource.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(resource));
      return Resource.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<Resource> mockResourceList = resourceList().toList();
  Future<List<Resource>> getOrgList() async => mockResourceList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<Resource> resourceList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var resource = Resource(name: name);
    yield resource;
  }
}