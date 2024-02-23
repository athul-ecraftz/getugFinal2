import 'package:json_annotation/json_annotation.dart';
part 'update_password.g.dart';

@JsonSerializable()
class update_password {
  String? status;
  String? time;
  String? data;

  update_password({this.status, this.time, this.data});

  update_password.fromJson(Map<String, dynamic> json) {
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
