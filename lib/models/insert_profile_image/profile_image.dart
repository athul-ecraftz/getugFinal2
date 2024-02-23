import 'package:json_annotation/json_annotation.dart';
part 'profile_image.g.dart';

@JsonSerializable()
class profile_image {
  String? status;
  String? time;
  String? data;

  profile_image({this.status, this.time, this.data});

  profile_image.fromJson(Map<String, dynamic> json) {
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
