import 'package:json_annotation/json_annotation.dart';
part 'registerby_email_verifyotp.g.dart';

@JsonSerializable()
class registerby_email_verifyotp {
  String? status;
  String? time;
  String? data;
  Map<String, dynamic>? user;
  registerby_email_verifyotp({this.status, this.time, this.data, this.user});

  registerby_email_verifyotp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    data = json['data'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    data['data'] = this.data;
    data['user'] = this.user;
    return data;
  }
}
