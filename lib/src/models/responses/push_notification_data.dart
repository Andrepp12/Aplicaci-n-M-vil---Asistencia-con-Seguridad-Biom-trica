class PushNotificationData {
  final String? goto;
  final bool? gotoWhileOpen;

  PushNotificationData({
    required this.goto,
    required this.gotoWhileOpen,
  });

  factory PushNotificationData.fromMap(Map<String, dynamic> map) {
    return PushNotificationData(
      goto: map['goto'],
      gotoWhileOpen: map['goto_while_open'] == 'true',
    );
  }
}
