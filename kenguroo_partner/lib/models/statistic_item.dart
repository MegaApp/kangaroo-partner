class StatisticItem {
  int count;
  String name;
  int total;
  String date;

  StatisticItem({this.count, this.name, this.total, this.date});

  factory StatisticItem.fromJson(Map<String, dynamic> json) {
    return StatisticItem(
        count: json['count'],
        name: json['name'],
        total: json['total'],
        date: json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['name'] = this.name;
    data['total'] = this.total;
    data['date'] = this.date;
    return data;
  }
}
