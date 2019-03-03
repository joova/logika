class Product {
  String id;
  String name;


  Product({
    this.id, 
    this.name
  });

  factory Product.fromJson(Map<String, dynamic> product) => 
    Product(
      id: product['id'], 
      name: product['name']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name
    };
}