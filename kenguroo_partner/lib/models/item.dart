class Item {
    int count;
    String name;
    String price;

    Item({required this.count, required this.name, required this.price});

    factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
            count: json['count'], 
            name: json['name'],
            price: json['price']
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['count'] = this.count;
        data['name'] = this.name;
        data['price'] = this.price;
        return data;
    }
}