
class PinVerifyModel {
  final Message message;
  final Data data;

  PinVerifyModel({
    required this.message,
    required this.data,
  });

  factory PinVerifyModel.fromJson(Map<String, dynamic> json) => PinVerifyModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final bool matchStatus;

  Data({
    required this.matchStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    matchStatus: json["match_status"],
  );
}

class Message {
  final List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: List<String>.from(json["success"].map((x) => x)),
  );
}
