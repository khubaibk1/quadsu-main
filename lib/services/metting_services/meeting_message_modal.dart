class MeetingMessageModal {
  String message;
  int ownerId;

  MeetingMessageModal({
    required this.message,
    required this.ownerId,
  });
  factory MeetingMessageModal.fromJson(Map json) {
    return MeetingMessageModal(
        message: json['message'], ownerId: json['ownerId']);
  }

  toJson() {
    return {
      'message': message,
      'ownerId': ownerId,
    };
  }
}
