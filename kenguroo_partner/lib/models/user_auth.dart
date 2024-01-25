class UserAuth {
  String access;
  bool isFirstLogin;
  String refresh;

  UserAuth({required this.access, required this.isFirstLogin, required this.refresh});

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      access: json['access'],
      isFirstLogin: json['is_first_login'],
      refresh: json['refresh'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access'] = this.access;
    data['is_first_login'] = this.isFirstLogin;
    data['refresh'] = this.refresh;
    return data;
  }
}
