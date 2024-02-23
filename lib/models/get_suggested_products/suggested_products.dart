import 'package:json_annotation/json_annotation.dart';
part 'suggested_products.g.dart';

@JsonSerializable()
class suggested_products {
  String? status;
  String? time;
  List<Data>? data;

  suggested_products({this.status, this.time, this.data});

  suggested_products.fromJson(Map<String, dynamic> json) {
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
  String? productType;
  String? cover;

  Data({this.id, this.name, this.price, this.productType, this.cover});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    productType = json['productType'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['productType'] = this.productType;
    data['cover'] = this.cover;
    return data;
  }
}
