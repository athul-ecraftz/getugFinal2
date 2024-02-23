import 'package:json_annotation/json_annotation.dart';
part 'user_login.g.dart';

@JsonSerializable()
class Login {
  @JsonKey(name: "userName")
  String? userName;
  @JsonKey(name: "mobileNumber")
  int? mobileNumber;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "alternateNumber")
  int? alternateNumber;
  @JsonKey(name: "userId")
  int? userId;
  @JsonKey(name: "registerPlatformId")
  int? registerPlatformId;

  Login(
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

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}

// class LoginResponse {
//   String? userName;
//   int? mobileNumber;
//   String? email;
//   String? photo;
//   String? firstName;
//   String? lastName;
//   String? description;
//   int? alternateNumber;
//   int? userId;
//   int? registerPlatformId;

//   LoginResponse(
//       {this.userName,
//       this.mobileNumber,
//       this.email,
//       this.photo,
//       this.firstName,
//       this.lastName,
//       this.description,
//       this.alternateNumber,
//       this.userId,
//       this.registerPlatformId});

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       userName: json["userName"] != null ? json["userName"] : "",
//       mobileNumber: json["mobileNumber"] != null ? json["mobileNumber"] : "",
//       email: json["email"] != null ? json["email"] : "",
//       photo: json["photo"] != null ? json["photo"] : "",
//       firstName: json["firstName"] != null ? json["firstName"] : "",
//       lastName: json["lastName"] != null ? json["lastName"] : "",
//       description: json["description"] != null ? json["description"] : "",
//       alternateNumber:
//           json["alternateNumber"] != null ? json["alternateNumber"] : "",
//       userId: json["userId"] != null ? json["userId"] : "",
//       registerPlatformId:
//           json["registerPlatformId"] != null ? json["registerPlatformId"] : "",
//     );
//   }
// }

// class LoginRequest {
//   String? email;
//   String? password;
//   String? loginType;

//   LoginRequest({this.email, this.password, this.loginType});

//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> map = {
//       'email': email?.trim(),
//       'password': password?.trim(),
//       'loginType': loginType?.trim()
//     };
//     return map;
//   }
// }
