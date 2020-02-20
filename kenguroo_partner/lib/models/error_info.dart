class ErrorInfo {
  int code;
  String description;
  String message;

  ErrorInfo({this.code, this.description, this.message});

  factory ErrorInfo.fromJson(Map<String, dynamic> json) {
    return ErrorInfo(
      code: json['code'],
      description: json['description'],
      message: json['message'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    data['message'] = this.message;
    return data;
  }
}
