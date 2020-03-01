import 'models.dart';

class Store {
    int delivery;
    String id;
    String image;
    bool isFavorite;
    String name;
    double rating;
    List<Tag> tags;

    Store({this.delivery, this.id, this.image, this.isFavorite, this.name, this.rating, this.tags});

    factory Store.fromJson(Map<String, dynamic> json) {
        return Store(
            delivery: json['delivery'], 
            id: json['id'], 
            image: json['image'], 
            isFavorite: json['isFavorite'], 
            name: json['name'], 
            rating: json['rating'], 
            tags: json['tags'] != null ? (json['tags'] as List).map((i) => Tag.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['delivery'] = this.delivery;
        data['id'] = this.id;
        data['image'] = this.image;
        data['isFavorite'] = this.isFavorite;
        data['name'] = this.name;
        data['rating'] = this.rating;
        if (this.tags != null) {
            data['tags'] = this.tags.map((v) => v.toJson()).toList();
        }
        return data;
    }
}