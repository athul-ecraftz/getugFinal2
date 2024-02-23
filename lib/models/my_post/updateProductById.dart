import 'package:json_annotation/json_annotation.dart';
part 'updateProductById.g.dart';

@JsonSerializable()
class UpdateProductById {
  String? status;
  String? time;
  int? data;

  UpdateProductById({this.status, this.time, this.data});

  UpdateProductById.fromJson(Map<String, dynamic> json) {
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
