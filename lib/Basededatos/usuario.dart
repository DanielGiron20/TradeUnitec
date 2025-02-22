class Usuario {
  String id;
  String uid;
  String name;
  String email;
  String description;
  String logo;
  String phoneNumber;

  Usuario({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.description,
    required this.logo,
    required this.phoneNumber,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'email': email,
      'description': description,
      'logo': logo,
      'phoneNumber': phoneNumber,
    };
  }
}
