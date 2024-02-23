import 'package:json_annotation/json_annotation.dart';
part 'related_product.g.dart';

@JsonSerializable()
class Related_product {
  String? status;
  String? time;
  List<Data1>? data;

  Related_product({this.status, this.time, this.data});

  Related_product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data1>[];
      json['data'].forEach((v) {
        data!.add(new Data1.fromJson(v));
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

class Data1 {
  int? id;
  String? name;
  String? price;
  String? cover;
  String? conditionName;
  String? wishlist;
  String? productType;
  Null? isAproved;

  Data1(
      {this.id,
      this.name,
      this.price,
      this.cover,
      this.conditionName,
      this.wishlist,
      this.productType,
      this.isAproved});

  Data1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    cover = json['cover'];
    conditionName = json['conditionName'];
    wishlist = json['wishlist'];
    productType = json['productType'];
    isAproved = json['isAproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['cover'] = this.cover;
    data['conditionName'] = this.conditionName;
    data['wishlist'] = this.wishlist;
    data['productType'] = this.productType;
    data['isAproved'] = this.isAproved;
    return data;
  }
}
