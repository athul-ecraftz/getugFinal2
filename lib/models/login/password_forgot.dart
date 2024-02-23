import 'package:json_annotation/json_annotation.dart';
part 'password_forgot.g.dart';

@JsonSerializable()
class Forgot_password {
  String? status;
  String? time;
  int? otp;
  String? data;
  Map<String, dynamic>? user;

  Forgot_password({this.status, this.time, this.otp, this.user, this.data});

  Forgot_password.fromJson(Map<String, dynamic> json) {
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

class User {
  String? userName;
  String? mobileNumber;
  String? email;
  String? photo;
  String? firstName;
  String? lastName;
  String? description;
  String? alternateNumber;
  int? userId;
  int? registerPlatformId;

  User(
      {this.userName,
      this.mobileNumber,
      this.email,
      this.photo,
      this.firstName,
      this.lastName,
      this.description,
      this.alternateNumber,
      this.userId,
      this.registerPlatformId});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    photo = json['photo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    description = json['description'];
    alternateNumber = json['alternateNumber'];
    userId = json['userId'];
    registerPlatformId = json['registerPlatformId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['description'] = this.description;
    data['alternateNumber'] = this.alternateNumber;
    data['userId'] = this.userId;
    data['registerPlatformId'] = this.registerPlatformId;
    return data;
  }
}
