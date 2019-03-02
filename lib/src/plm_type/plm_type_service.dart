import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/plm_type/plm_type.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class PlmTypeService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _plmUrl = 'http://localhost:8001/api/plm'; // URL to web API
  final Client _http;
  
  PlmTypeService(this._http);

  Future<List<PlmType>> getAll() async {
    try {
      final response = await _http.get('$_plmUrl/PlmTypes');
      final data = _extractData(response) as List;
      final plmType = (data)
          .map((value) => PlmType.fromJson(value))
          .toList();
      return plmType;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/types/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<PlmType>());
        return paging;
      }
        

      final plmType = (data).map((value) => PlmType.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plmType);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/types/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final plmType = (data).map((value) => PlmType.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plmType);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmType> get(String code) async {
    try {
      final response = await _http.get('$_plmUrl/type/$code');
      
      return PlmType.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmType> create(PlmType plm_type) async {
    print(json.encode(plm_type));
    try {
      final response = await _http.post(
        '$_plmUrl/type',
        headers: _headers, 
        body: json.encode(plm_type),
      );
      return PlmType.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmType> update(PlmType plmType) async {
    try {
      final url = '$_plmUrl/type/${plmType.code}';
      final response = await _http.put(url, headers: _headers, body: json.encode(plmType));
      return PlmType.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<PlmType> mockPlm_typeList = plmTypeList().toList();
  Future<List<PlmType>> getPlmTypeList() async => mockPlm_typeList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<PlmType> plmTypeList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var plmType = PlmType(name: name);
    yield plmType;
  }
}