import 'models.dart';

class Menu {
    String id;
    bool active;
    String name;
    String price;

    Menu({required this.id, required this.price, required this.active, required this.name});

    factory Menu.fromJson(Map<String, dynamic> json) {
        return Menu(
            id: json['id'],
            price: json['price'],
            active: json['active'],
            name:  json['name']
        );
    }
}