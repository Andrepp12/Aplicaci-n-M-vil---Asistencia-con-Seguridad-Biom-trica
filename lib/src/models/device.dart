class Device {
  final String id;
  final String userId;
  final String token;

  Device({
    required this.id,
    required this.userId,
    required this.token,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      userId: json['userId'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'token': token,
      };
}
