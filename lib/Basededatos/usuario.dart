class Usuario {
  String id;
  // ignore: non_constant_identifier_names
  String UID;
  String name;
  String email;
  String description;
  String logo;

  Usuario({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.UID,
    required this.name,
    required this.email,
    required this.description,
    required this.logo,
  });

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        UID = json['UID'] ?? "",
        name = json['name'] ?? "",
        email = json['email'] ?? "",
        description = json['description'] ?? "",
        logo = json['logo'] ?? "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['UID'] = UID;
    data['name'] = name;
    data['email'] = email;
    data['description'] = description;
    data['logo'] = logo;
    return data;
  }
}
