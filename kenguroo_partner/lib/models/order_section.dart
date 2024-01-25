import 'models.dart';

class OrderSection {
    String time;
    List<Order> items;

    OrderSection({required this.time, required this.items});

    factory OrderSection.fromJson(Map<String, dynamic> json) {
        return OrderSection(
            time: json['time'],
            items: json['items'] != null ? (json['items'] as List).map((i) => Order.fromJson(i)).toList() : List.empty(),
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['time'] = this.time;
        if (this.items != null) {
            data['items'] = this.items.map((v) => v.toJson()).toList();
        }
        return data;
    }
}