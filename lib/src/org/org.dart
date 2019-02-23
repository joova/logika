class Org {
  String id;
  String name;


  Org({
    this.id, 
    this.name
  });

  factory Org.fromJson(Map<String, dynamic> org) => 
    Org(
      id: org['id'], 
      name: org['name']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name
    };
}