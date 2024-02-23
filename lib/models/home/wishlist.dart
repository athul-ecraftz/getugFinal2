import 'package:json_annotation/json_annotation.dart';
part 'wishlist.g.dart';

@JsonSerializable()
class Wishlist {
  String? status;
  String? time;
  int? data;

  Wishlist({this.status, this.time, this.data});

  Wishlist.fromJson(Map<String, dynamic> json) {
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
