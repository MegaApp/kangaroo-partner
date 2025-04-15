import 'models.dart';

class Order {
  String driver;
  String id;
  List<Item> items;
  int number;
  String orderedAt;
  String price;
  String status;
  int itemsCount;
  String comment;
  bool cash;

  Order(
      {required this.driver,
      required this.id,
      required this.items,
      required this.number,
      required this.orderedAt,
      required this.price,
      required this.status,
      required this.itemsCount,
      required this.comment,
      required this.cash});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        driver: json['driver'],
        id: json['id'],
        items: json['items'] != null
            ? (json['items'] as List).map((i) => Item.fromJson(i)).toList()
            : List.empty(),
        number: json['number'],
        orderedAt: json['ordered_at'],
        price: json['price'],
        status: json['status'],
        itemsCount: json['items_count'],
        comment: json['comment'],
        cash: json["cash"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver'] = this.driver;
    data['id'] = this.id;
    data['number'] = this.number;
    data['ordered_at'] = this.orderedAt;
    data['price'] = this.price;
    data['status'] = this.status;
    data['items_count'] = this.itemsCount;
    data['comment'] = this.comment;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data["cash"] = this.cash;
    return data;
  }
}
