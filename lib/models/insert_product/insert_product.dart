import 'package:json_annotation/json_annotation.dart';
part 'insert_product.g.dart';

@JsonSerializable()
class insert_product {
  String? status;
  String? time;
  int? data;

  insert_product({this.status, this.time, this.data});

  insert_product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['data'] = this.data;
    return data;
  }
}
