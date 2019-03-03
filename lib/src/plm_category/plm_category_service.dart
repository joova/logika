import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';

import 'package:logika/src/plm_category/plm_category.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class PlmCategoryService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _plmUrl = 'http://localhost:8001/api/plm'; // URL to web API
  final Client _http;
  
  PlmCategoryService(this._http);

  Future<List<PlmCategory>> getAll() async {
    try {
      final response = await _http.get('$_plmUrl/categories');
      final data = _extractData(response) as List;
      final plm_categories = (data)
          .map((value) => PlmCategory.fromJson(value))
          .toList();
      return plm_categories;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/categories/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<PlmCategory>());
        return paging;
      }
        

      final plm_categories = (data).map((value) => PlmCategory.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plm_categories);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_plmUrl/categories/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final plm_categories = (data).map((value) => PlmCategory.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), plm_categories);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmCategory> get(String code) async {
    try {
      final response = await _http.get('$_plmUrl/category/$code');
      
      return PlmCategory.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmCategory> create(PlmCategory plm_category) async {
    print(json.encode(plm_category));
    try {
      final response = await _http.post(
        '$_plmUrl/category',
        headers: _headers, 
        body: json.encode(plm_category),
      );
      return PlmCategory.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlmCategory> delete(PlmCategory plm_category) async {
    try {
      final url = '$_plmUrl/category/${plm_category.code}';
      final response = await _http.delete(url);
      return PlmCategory.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<PlmCategory> mockPlmCategoryList = plm_cattegoryList().toList();
  Future<List<PlmCategory>> getPlmCategoryList() async => mockPlmCategoryList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<PlmCategory> plm_cattegoryList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var plm_category = PlmCategory(name: name);
    yield plm_category;
  }
}