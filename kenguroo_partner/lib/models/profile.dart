class Profile {
  String name;
  String image;
  bool active;
  int rating;

  Profile({required this.name, required this.image, required this.active, required this.rating});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      image: json['logo'],
      active: json['active'],
      rating: json['rating']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.image;
    data['active'] = this.active;
    return data;
  }
}
