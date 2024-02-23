import 'package:json_annotation/json_annotation.dart';
part 'update_notification.g.dart';

@JsonSerializable()
class update_notification {
  String? status;
  String? time;
  String? data;

  update_notification({this.status, this.time, this.data});

  update_notification.fromJson(Map<String, dynamic> json) {
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
