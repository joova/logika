import 'package:angular_components/model/ui/display_name.dart';

class Product {
  String id;
  String name;
  String description;
  String code;
  UOM uom;
  PlmType type;
  PlmCategory category;

  Product({this.id, this.name, this.code, this.uom, this.type, this.category});

  factory Product.fromJson(Map<String, dynamic> product) => Product(
        id: product['id'],
        name: product['name'],
        code: product['code'],
        uom: UOM.fromJson(product['uom']),
        type: PlmType.fromJson(product['type']),
        category: PlmCategory.fromJson(product['category']),
      );

  Map toJson() => {
        // 'id': id,
        'name': name,
        'code': code,
        'uom': uom.toJson(),
        'type': type.toJson(),
        'category': category.toJson()
      };
}

class UOM implements HasUIDisplayName{
  String code;
  String name;

  UOM({
    this.name,
    this.code,
  });

  factory UOM.fromJson(Map<String, dynamic> uom) => UOM(
        name: uom['name'],
        code: uom['code'],
      );

  Map toJson() => {'code': code, 'name': name};

  @override
  String get uiDisplayName => name;

  bool operator ==(Object other) => (other is UOM && this.code == other.code);
}

class PlmType implements HasUIDisplayName{
  String code;
  String name;

  PlmType({
    this.name,
    this.code,
  });

  factory PlmType.fromJson(Map<String, dynamic> plmType) => PlmType(
        name: plmType['name'],
        code: plmType['code'],
      );

  Map toJson() => {'code': code, 'name': name};

  @override
  String get uiDisplayName => name;

  bool operator ==(Object other) =>
      (other is PlmType && this.code == other.code);
}

class PlmCategory implements HasUIDisplayName{
  String code;
  String name;

  PlmCategory({
    this.name,
    this.code,
  });

  factory PlmCategory.fromJson(Map<String, dynamic> plmCategory) => PlmCategory(
        name: plmCategory['name'],
        code: plmCategory['code'],
      );

  Map toJson() => {'code': code, 'name': name};

  @override
  String get uiDisplayName => name;

  bool operator ==(Object other) =>
      (other is PlmCategory && this.code == other.code);
}
