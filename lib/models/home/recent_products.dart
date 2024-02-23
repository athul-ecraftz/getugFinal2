import 'package:json_annotation/json_annotation.dart';
part 'recent_products.g.dart';

@JsonSerializable()
class Recent_products {
  String? status;
  String? time;
  List<Data>? data;

  Recent_products({this.status, this.time, this.data});

  Recent_products.fromJson(Map<String, dynamic> json) {
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
  String? price;
  String? conditionName;
  int? productStatusId;
  String? wishlist;
  String? cover;
  String? productType;

  Data(
      {this.id,
      this.name,
      this.price,
      this.conditionName,
      this.productStatusId,
      this.wishlist,
      this.cover,
      this.productType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    conditionName = json['conditionName'];
    productStatusId = json['productStatusId'];
    wishlist = json['wishlist'];
    cover = json['cover'];
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['conditionName'] = this.conditionName;
    data['productStatusId'] = this.productStatusId;
    data['wishlist'] = this.wishlist;
    data['cover'] = this.cover;
    data['productType'] = this.productType;
    return data;
  }
}
