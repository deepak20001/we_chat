// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String? toId;
  String? msg;
  String? read;
  String? sent;
  String? fromId;
  Type? type;

  Message({this.toId, this.msg, this.read, this.type, this.sent, this.fromId});

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type!.name;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }

}

enum Type {text, image}
