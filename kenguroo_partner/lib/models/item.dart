import 'models.dart';

class Item {
    int count;
    String name;

    Item({this.count, this.name});

    factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
            count: json['count'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['count'] = this.count;
        data['name'] = this.name;
        return data;
    }
}