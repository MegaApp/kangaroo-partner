import 'models.dart';

class Menu {
    String id;
    String image;
    String name;
    String price;

    Menu({this.id, this.image, this.name, this.price});

    factory Menu.fromJson(Map<String, dynamic> json) {
        return Menu(
            id: json['id'], 
            image: json['image'], 
            name: json['name'], 
            price: json['price'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['image'] = this.image;
        data['name'] = this.name;
        data['price'] = this.price;
        return data;
    }
}