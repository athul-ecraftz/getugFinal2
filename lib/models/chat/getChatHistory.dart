import 'package:json_annotation/json_annotation.dart';
part 'getChatHistory.g.dart';

@JsonSerializable()
class ChatHistory {
  String? status;
  String? time;
  List<Data>? data;

  ChatHistory({this.status, this.time, this.data});

  ChatHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? type;
  String? message;
  bool? incoming;
  bool? outgoing;
  String? sentTime;
  String? subtype;
  String? file;
  String? fileName;

  Data(
      {this.type,
      this.message,
      this.incoming,
      this.outgoing,
      this.sentTime,
      this.subtype,
      this.file,
      this.fileName});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    incoming = json['incoming'];
    outgoing = json['outgoing'];
    sentTime = json['sentTime'];
    subtype = json['subtype'];
    file = json['file'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['message'] = this.message;
    data['incoming'] = this.incoming;
    data['outgoing'] = this.outgoing;
    data['sentTime'] = this.sentTime;
    data['subtype'] = this.subtype;
    data['file'] = this.file;
    data['fileName'] = this.fileName;
    return data;
  }
}
