import 'package:json_annotation/json_annotation.dart';
part 'producttype.g.dart';

@JsonSerializable()
class ProductType {
  int? productTypeId;
  String? productTypeName;
  String? data;

  ProductType({this.productTypeId, this.productTypeName, this.data});

  ProductType.fromJson(Map<String, dynamic> json) {
    productTypeId = json['productTypeId'];
    productTypeName = json['productTypeName'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productTypeId'] = this.productTypeId;
    data['productTypeName'] = this.productTypeName;
    data['data'] = this.data;
    return data;
  }
}
