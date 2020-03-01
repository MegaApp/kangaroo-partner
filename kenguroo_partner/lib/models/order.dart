import 'models.dart';

class Order {
    String deliveryDate;
    String deliveryPrice;
    String discount;
    String foodPrice;
    String id;
    String status;
    List<StoreSection> stores;
    String totalPrice;
    String totalPriceWithDiscount;

    Order({this.deliveryDate, this.deliveryPrice, this.discount, this.foodPrice, this.id, this.status, this.stores, this.totalPrice, this.totalPriceWithDiscount});

    factory Order.fromJson(Map<String, dynamic> json) {
        return Order(
            deliveryDate: json['deliveryDate'], 
            deliveryPrice: json['deliveryPrice'], 
            discount: json['discount'], 
            foodPrice: json['foodPrice'], 
            id: json['id'], 
            status: json['status'], 
            stores: json['stores'] != null ? (json['stores'] as List).map((i) => StoreSection.fromJson(i)).toList() : null,
            totalPrice: json['totalPrice'], 
            totalPriceWithDiscount: json['totalPriceWithDiscount'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['deliveryDate'] = this.deliveryDate;
        data['deliveryPrice'] = this.deliveryPrice;
        data['discount'] = this.discount;
        data['foodPrice'] = this.foodPrice;
        data['id'] = this.id;
        data['status'] = this.status;
        data['totalPrice'] = this.totalPrice;
        data['totalPriceWithDiscount'] = this.totalPriceWithDiscount;
        if (this.stores != null) {
            data['stores'] = this.stores.map((v) => v.toJson()).toList();
        }
        return data;
    }
}