class User {
  String id;
  String username;
  String password;
  String firstName;
  String lastName;

  User({
    this.id, 
    this.username, 
    this.password, 
    this.firstName, 
    this.lastName
  });

  factory User.fromJson(Map<String, dynamic> user) => 
    User(
      id: user['id'], 
      username: user['username'], 
      password: user['password'],
      firstName: user['first_name'], 
      lastName: user['last_name']
    );

  Map toJson() => {
    // 'id': _id, 
    'username': username,
    'password': password,
    'first_name': firstName,
    'last_name': lastName
    };
}