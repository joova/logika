class User {
  String id;
  String username;
  String password;

  User({this.id, this.username, this.password});

  factory User.fromJson(Map<String, dynamic> user) => 
    User(
      id: user['id'], 
      username: user['username'], 
      password: user['password']
    );

  Map toJson() => {
    // 'id': _id, 
    'username': username,
    'password': password
    };
}