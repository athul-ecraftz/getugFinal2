import 'package:json_annotation/json_annotation.dart';
part 'signup_with_email.g.dart';

@JsonSerializable()
class signup_with_email {
  String? status;
  String? time;
  int? otp;
  String? data;

  signup_with_email({this.status, this.time, this.otp, this.data});

  signup_with_email.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    otp = json['otp'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['otp'] = this.otp;
    data['data'] = this.data;
    return data;
  }
}
