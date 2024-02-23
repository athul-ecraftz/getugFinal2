import 'package:json_annotation/json_annotation.dart';
part 'forgot_password.g.dart';

@JsonSerializable()
class forgot_password {
  String? status;
  String? time;
  int? otp;
  String? user;

  forgot_password({this.status, this.time, this.otp, this.user});

  forgot_password.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    otp = json['otp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['otp'] = this.otp;
    data['user'] = this.user;
    return data;
  }
}
