import 'models.dart';

class Question {
  String answer;
  String id;
  String question;
  String title;

  Question({this.answer, this.id, this.question, this.title});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        answer: json['answer'],
        id: json['id'],
        question: json['question'],
        title: json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['id'] = this.id;
    data['question'] = this.question;
    data['title'] = this.title;
    return data;
  }
}
