import 'models.dart';

class Menu {
    String id;
    bool active;
    String name;
    String price;

    Menu({this.id, this.price, this.active, this.name});

    factory Menu.fromJson(Map<String, dynamic> json) {
        return Menu(
            id: json['id'],
            price: json['price'],
            active: json['active'],
            name:  json['name']
        );
    }
}