import 'package:json_annotation/json_annotation.dart';
part 'get_category.g.dart';

@JsonSerializable()
class Get_category {
  String? status;
  String? time;
  List<Data>? data;

  Get_category({this.status, this.time, this.data});

  Get_category.fromJson(Map<String, dynamic> json) {
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

@JsonSerializable()
class Data {
  int? id;
  String? name;
  String? price;
  int? productStatusId;
  String? cover;
  String? conditionName;
  String? wishlist;
  int? stateId;
  String? productType;

  Data(
      {this.id,
      this.name,
      this.price,
      this.productStatusId,
      this.cover,
      this.conditionName,
      this.wishlist,
      this.stateId,
      this.productType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    productStatusId = json['productStatusId'];
    cover = json['cover'];
    conditionName = json['conditionName'];
    wishlist = json['wishlist'];
    stateId = json['stateId'];
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['productStatusId'] = this.productStatusId;
    data['cover'] = this.cover;
    data['conditionName'] = this.conditionName;
    data['wishlist'] = this.wishlist;
    data['stateId'] = this.stateId;
    data['productType'] = this.productType;
    return data;
  }
}
