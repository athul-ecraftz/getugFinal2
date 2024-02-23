import 'package:json_annotation/json_annotation.dart';
part 'sendAudioChat.g.dart';

@JsonSerializable()
class sendAudioChat {
  String? status;
  String? time;
  String? data;

  sendAudioChat({this.status, this.time, this.data});

  sendAudioChat.fromJson(Map<String, dynamic> json) {
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
