import 'package:json_annotation/json_annotation.dart';
part 'verify_usersend_otp.g.dart';

@JsonSerializable()
class verify_usersend_otp {
  String? status;
  String? time;
  int? otp;
  int? userId;

  verify_usersend_otp({this.status, this.time, this.otp, this.userId});

  verify_usersend_otp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    otp = json['otp'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['otp'] = this.otp;
    data['userId'] = this.userId;
    return data;
  }
}
