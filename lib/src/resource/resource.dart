class Resource {
  String id;
  String name;
  String uri;


  Resource({
    this.id, 
    this.name,
    this.uri
  });

  factory Resource.fromJson(Map<String, dynamic> org) => 
    Resource(
      id: org['id'], 
      name: org['name'],
      uri: org['uri']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name,
    'uri': uri
    };
}