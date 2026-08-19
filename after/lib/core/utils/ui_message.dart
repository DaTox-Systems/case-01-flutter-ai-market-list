enum MessageType { success, error, info }

class UiMessage {
  final String title;
  final String description;
  final MessageType type;

  const UiMessage({
    required this.title,
    required this.description,
    this.type = MessageType.info,
  });

  const UiMessage.success({
    required this.title,
    required this.description,
  }) : type = MessageType.success;

  const UiMessage.error({
    required this.title,
    required this.description,
  }) : type = MessageType.error;

  const UiMessage.info({
    required this.title,
    required this.description,
  }) : type = MessageType.info;
}
