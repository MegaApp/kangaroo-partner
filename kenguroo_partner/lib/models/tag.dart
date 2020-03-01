import 'models.dart';

class Tag {
    String id;
    String key;
    String name;

    Tag({this.id, this.key, this.name});

    factory Tag.fromJson(Map<String, dynamic> json) {
        return Tag(
            id: json['id'], 
            key: json['key'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['key'] = this.key;
        data['name'] = this.name;
        return data;
    }
}