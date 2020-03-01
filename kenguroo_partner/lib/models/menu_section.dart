import 'models.dart';

class MenuSection {
    int count;
    Menu item;

    MenuSection({this.count, this.item});

    factory MenuSection.fromJson(Map<String, dynamic> json) {
        return MenuSection(
            count: json['count'], 
            item: json['item'] != null ? Menu.fromJson(json['item']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['count'] = this.count;
        if (this.item != null) {
            data['item'] = this.item.toJson();
        }
        return data;
    }
}