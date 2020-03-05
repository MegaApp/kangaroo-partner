import 'models.dart';

class Order {
    String driver;
    String id;
    List<Item> items;
    int number;
    String ordered_at;
    String price;
    String status;

    Order({this.driver, this.id, this.items, this.number, this.ordered_at, this.price, this.status});

    factory Order.fromJson(Map<String, dynamic> json) {
        return Order(
            driver: json['driver'], 
            id: json['id'], 
            items: json['items'] != null ? (json['items'] as List).map((i) => Item.fromJson(i)).toList() : null, 
            number: json['number'], 
            ordered_at: json['ordered_at'], 
            price: json['price'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['driver'] = this.driver;
        data['id'] = this.id;
        data['number'] = this.number;
        data['ordered_at'] = this.ordered_at;
        data['price'] = this.price;
        data['status'] = this.status;
        if (this.items != null) {
            data['items'] = this.items.map((v) => v.toJson()).toList();
        }
        return data;
    }
}