import 'package:json_annotation/json_annotation.dart';
part 'product_image.g.dart';

@JsonSerializable()
class product_image {
  String? status;
  String? time;
  String? data;

  product_image({this.status, this.time, this.data});

  product_image.fromJson(Map<String, dynamic> json) {
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
