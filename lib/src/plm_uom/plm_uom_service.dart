import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/plm_uom/plm_uom.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class PlmUomService {
  static final _headers = {'Content-Type': 'application/json'};
  // static const _plmUrl = 'http://localhost:8001/api/plm'; // URL to web LOKAL
   static const _plmUrl = 'http://192.168.100.35:8001/api/plm'; // URL to web API
  final Client _http;
  
  PlmUomService(this._http);

  Future<List<PlmUom>> getAll() async {
    try {
      final response = await _http.get('$_plmUrl/uoms');
      final data = _extractData(response) as List;
      final plmUoms = (data)
          .map((value) => PlmUom.fromJson(value))
          .toList();
      return plmUoms;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/uoms/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<PlmUom>());
        return paging;
      }
        

      final plmUoms = (data).map((value) => PlmUom.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plmUoms);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/uoms/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final plmUom = (data).map((value) => PlmUom.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plmUom);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmUom> get(String code) async {
    try {
      final response = await _http.get('$_plmUrl/uom/$code');
      
      return PlmUom.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmUom> create(PlmUom plmUom) async {
    print(json.encode(plmUom));
    try {
      final response = await _http.post(
        '$_plmUrl/uom',
        headers: _headers, 
        body: json.encode(plmUom),
      );
      return PlmUom.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmUom> update(PlmUom plmUom) async {
    try {
      final url = '$_plmUrl/uom/${plmUom.code}';
      final response = await _http.put(url, headers: _headers, body: json.encode(plmUom));
      return PlmUom.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<PlmUom> mockPlmUomList = plmUomList().toList();
  Future<List<PlmUom>> getPlmUomList() async => mockPlmUomList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<PlmUom> plmUomList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var plmUom = PlmUom(name: name);
    yield plmUom;
  }
}