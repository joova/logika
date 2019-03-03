import 'dart:async';
import 'dart:convert';

import 'package:angular/core.dart';
import 'package:http/http.dart';
import 'package:logika/src/pagination_service.dart';
import 'package:logika/src/product/product.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class ProductService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _idmUrl = 'http://localhost:8001/api/'; // URL to web API
  final Client _http;
  
  ProductService(this._http);

  Future<List<Product>> getAll() async {
    try {
      final response = await _http.get('$_idmUrl/products');
      final data = _extractData(response) as List;
      final products = (data)
          .map((value) => Product.fromJson(value))
          .toList();
      return products;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> getPaging(int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/products/$off/$lmt');
      
      final data = _extractData(response) as List;
      if(data == null) {
        final Pagination paging = new Pagination(0, 0, 0, List<Product>());
        return paging;
      }
        

      final products = (data).map((value) => Product.fromJson(value)).toList();
      
      final headers = response.headers;
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
     
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), products);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pagination> search(String text, int off, int lmt) async {
    try {
      final response = await _http.get('$_idmUrl/products/$off/$lmt/$text');
      
      final data = _extractData(response) as List;
      final products = (data).map((value) => Product.fromJson(value)).toList();
      
      final headers = response.headers;
      
      final page = headers["pagination-page"];
      final count = headers["pagination-count"];
      final limit = headers["pagination-limit"];
      
      final Pagination paging = new Pagination(int.parse(page), int.parse(limit), int.parse(count), products);

      return paging;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> get(String id) async {
    try {
      final response = await _http.get('$_idmUrl/product/$id');
      
      return Product.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> create(Product product) async {
    print(json.encode(product));
    try {
      final response = await _http.post(
        '$_idmUrl/product',
        headers: _headers, 
        body: json.encode(product),
      );
      return Product.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> update(Product product) async {
    try {
      final url = '$_idmUrl/product/${product.id}';
      final response = await _http.put(url, headers: _headers, body: json.encode(product));
      return Product.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  List<Product> mockProductList = productList().toList();
  Future<List<Product>> getProductList() async => mockProductList;
}

dynamic _extractData(Response resp) => json.decode(resp.body);

Exception _handleError(dynamic e) {
  print(e); // for demo purposes only
  return Exception('Server error; cause: $e');
}

Iterable<Product> productList() sync* {
  var names = ['nur.hasyim@gmail.com', 'nuraida@gmail.com', 'ranomi@gmail.com'];

  for (var name in names) {
    var product = Product(name: name);
    yield product;
  }
}