class User {
  final int idUser;
  final String username;
  final String password;
  final String peran;

  User({
    required this.idUser,
    required this.username,
    required this.password,
    required this.peran,
  });

  factory User.fromJson(Map<String, dynamic> json, int id) {
    return User(
      idUser: id,
      username: json['username'],
      password: json['password'],
      peran: json['peran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "peran": peran,
    };
  }

}
