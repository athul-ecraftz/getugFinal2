import 'package:json_annotation/json_annotation.dart';
part 'productstatus.g.dart';

@JsonSerializable()
class ProductStatus {
  int? productStatusId;
  String? productStatusName;
  String? data;

  ProductStatus({this.productStatusId, this.productStatusName});

  ProductStatus.fromJson(Map<String, dynamic> json) {
    productStatusId = json['productStatusId'];
    productStatusName = json['productStatusName'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productStatusId'] = this.productStatusId;
    data['productStatusName'] = this.productStatusName;
    data['data'] = this.data;
    return data;
  }
}
