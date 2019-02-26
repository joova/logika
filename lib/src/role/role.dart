class Role {
  String id;
  String name;


  Role({
    this.id, 
    this.name
  });

  factory Role.fromJson(Map<String, dynamic> role) => 
    Role(
      id: role['id'], 
      name: role['name']
    );

  Map toJson() => {
    // 'id': _id, 
    'name': name
    };
}