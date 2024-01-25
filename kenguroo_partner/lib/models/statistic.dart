import 'package:kenguroo_partner/models/statistic_item.dart';

class Statistic {
  List<StatisticItem> items;
  int total;

  Statistic({
    required this.total,
    required this.items,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => StatisticItem.fromJson(i))
              .toList()
          : List.empty(),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
