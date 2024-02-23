import 'package:json_annotation/json_annotation.dart';

part 'resend_otp.g.dart';

@JsonSerializable()
class resend_otp {
  String? status;
  String? time;
  int? otp;

  resend_otp({this.status, this.time, this.otp});

  resend_otp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['otp'] = this.otp;
    return data;
  }
}
