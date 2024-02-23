import 'package:json_annotation/json_annotation.dart';
part 'product_condition.g.dart';

@JsonSerializable()
class ProductCondition {
  int? productConditionId;
  String? productConditionName;
  String? data;

  ProductCondition(
      {this.productConditionId, this.productConditionName, this.data});

  ProductCondition.fromJson(Map<String, dynamic> json) {
    productConditionId = json['productTypeId'];
    productConditionName = json['productTypeName'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productConditionId'] = this.productConditionId;
    data['productConditionName'] = this.productConditionName;
    data['data'] = this.data;
    return data;
  }
}
