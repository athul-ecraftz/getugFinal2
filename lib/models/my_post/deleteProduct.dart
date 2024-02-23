import 'package:json_annotation/json_annotation.dart';
part 'deleteProduct.g.dart';

@JsonSerializable()
class DeleteProduct {
  String? status;
  String? time;
  String? data;

  DeleteProduct({this.status, this.time, this.data});

  DeleteProduct.fromJson(Map<String, dynamic> json) {
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
