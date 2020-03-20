class Profile {
  String name;
  String image;

  Profile({this.name, this.image});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      image: json['logo'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.image;
    return data;
  }
}
