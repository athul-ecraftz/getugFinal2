import 'package:json_annotation/json_annotation.dart';
part 'soldupdateProductStatusById.g.dart';

@JsonSerializable()
class SoldUpdateProductById {
  String? status;
  String? time;
  String? data;

  SoldUpdateProductById({this.status, this.time, this.data});

  SoldUpdateProductById.fromJson(Map<String, dynamic> json) {
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
