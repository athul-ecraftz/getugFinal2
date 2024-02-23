import 'package:json_annotation/json_annotation.dart';
part 'confirm_password.g.dart';

@JsonSerializable()
class Confirm_password {
  String? status;
  String? time;
  String? data;

  Confirm_password({this.status, this.time, this.data});

  Confirm_password.fromJson(Map<String, dynamic> json) {
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
