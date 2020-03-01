import 'models.dart';

class StoreSection {
    String deliveryPrice;
    String discount;
    String foodPrice;
    List<MenuSection> items;
    Store store;
    String totalPrice;
    String totalPriceWithDiscount;

    StoreSection({this.deliveryPrice, this.discount, this.foodPrice, this.items, this.store, this.totalPrice, this.totalPriceWithDiscount});

    factory StoreSection.fromJson(Map<String, dynamic> json) {
        return StoreSection(
            deliveryPrice: json['deliveryPrice'], 
            discount: json['discount'], 
            foodPrice: json['foodPrice'], 
            items: json['items'] != null ? (json['items'] as List).map((i) => MenuSection.fromJson(i)).toList() : null,
            store: json['store'] != null ? Store.fromJson(json['store']) : null,
            totalPrice: json['totalPrice'], 
            totalPriceWithDiscount: json['totalPriceWithDiscount'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['deliveryPrice'] = this.deliveryPrice;
        data['discount'] = this.discount;
        data['foodPrice'] = this.foodPrice;
        data['totalPrice'] = this.totalPrice;
        data['totalPriceWithDiscount'] = this.totalPriceWithDiscount;
        if (this.items != null) {
            data['items'] = this.items.map((v) => v.toJson()).toList();
        }
        if (this.store != null) {
            data['store'] = this.store.toJson();
        }
        return data;
    }
}