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

  Map<String, dynamic> toMap() {
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

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      description: map['description'],
      logo: map['logo'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
