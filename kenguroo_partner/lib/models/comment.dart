class Comment {
  String comment;
  String date;
  int rating;

  Comment(this.comment, this.date, this.rating);

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(json['comment'], json['date'], json['rating'] ?? 0);
  }
}
