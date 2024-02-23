import 'package:json_annotation/json_annotation.dart';
part 'search_products.g.dart';

@JsonSerializable()
class search_products {
  String? status;
  String? time;
  List<Data>? data;

  search_products({this.status, this.time, this.data});

  search_products.fromJson(Map<String, dynamic> json) {
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
  String? productType;
  String? name;
  String? price;
  int? productStatusId;
  String? cover;
  String? wishlist;
  int? stateId;

  Data(
      {this.id,
      this.productType,
      this.name,
      this.price,
      this.productStatusId,
      this.cover,
      this.wishlist,
      this.stateId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productType = json['productType'];
    name = json['name'];
    price = json['price'];
    productStatusId = json['productStatusId'];
    cover = json['cover'];
    wishlist = json['wishlist'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productType'] = this.productType;
    data['name'] = this.name;
    data['price'] = this.price;
    data['productStatusId'] = this.productStatusId;
    data['cover'] = this.cover;
    data['wishlist'] = this.wishlist;
    data['stateId'] = this.stateId;
    return data;
  }
}
