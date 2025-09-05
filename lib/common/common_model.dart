import 'dart:convert';

CommonModel commonResponseFromJson(str) => CommonModel.fromJson(str);

String commonResponseToJson(CommonModel data) => json.encode(data.toJson());

class CommonModel {
  CommonModel({
    this.result,
    this.message,
    this.data,
    this.status,
  });

  bool? result;
  int? status;
  String? message;
  dynamic data;

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel(
    result: json["result"],
    message: json["message"],
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "status": status,
    "data": data,
  };
}