import 'package:json_annotation/json_annotation.dart';
part 'recent_post_products.g.dart';

@JsonSerializable()
class recent_post_products {
  String? status;
  String? time;
  List<Data>? data;

  recent_post_products({this.status, this.time, this.data});

  recent_post_products.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? productType;
  String? price;
  String? cover;
  String? conditionName;
  String? wishlist;

  Data(
      {this.id,
      this.name,
      this.productType,
      this.price,
      this.cover,
      this.conditionName,
      this.wishlist});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productType = json['productType'];
    price = json['price'];
    cover = json['cover'];
    conditionName = json['conditionName'];
    wishlist = json['wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productType'] = this.productType;
    data['price'] = this.price;
    data['cover'] = this.cover;
    data['conditionName'] = this.conditionName;
    data['wishlist'] = this.wishlist;
    return data;
  }
}
