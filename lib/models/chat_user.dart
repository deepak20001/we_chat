class ChatUser {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  String? lastActive;
  String? isOnline;
  String? id;
  String? pushToken;
  String? email;

  ChatUser(
      {this.image,
      this.about,
      this.name,
      this.createdAt,
      this.lastActive,
      this.isOnline,
      this.id,
      this.pushToken,
      this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    about = json['about'] ?? "";
    name = json['name'] ?? "";
    createdAt = json['created_at'] ?? "";
    lastActive = json['last_active'] ?? "";
    isOnline = json['is_online'] ?? "";
    id = json['id'] ?? "";
    pushToken = json['push_token'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}