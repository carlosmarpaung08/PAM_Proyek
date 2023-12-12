class User {
  final String? nim;
  final String? nama;
  final String? noKtp;
  final String? role;
  final String? nomorHandphone;
  final String? email;
  final String? password;

  User({
    this.nim,
    this.nama,
    this.noKtp,
    this.role,
    this.nomorHandphone,
    this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nim: json['nim'],
      nama: json['nama'],
      noKtp: json['noKtp'],
      role: json['role'],
      nomorHandphone: json['nomorHandphone'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim': nim,
      'nama': nama,
      'noKtp': noKtp,
      'role': role,
      'nomorHandphone': nomorHandphone,
      'email': email,
      'password': password,
    };
  }
}
