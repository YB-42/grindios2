class DiscordMessage {
  DiscordMessage({
    required this.username,
    required this.messageContent,
  });
  final String username;
  final String messageContent;

  factory DiscordMessage.fromString(String input) {
    if (RegExp(r"^\s*@").hasMatch(input)) {
      return DiscordMessage.fromReply(input);
    } else {
      return DiscordMessage.fromDirect(input);
    }
  }
  factory DiscordMessage.fromDirect(String input) {
    final String? username = RegExp(r"^([\w\-]+)").stringMatch(input);

    final String? messageContent = RegExp(r"[^AM|PM]*$").stringMatch(input);

    if (username != null && messageContent != null) {
      return DiscordMessage(
        username: username,
        messageContent: messageContent,
      );
    } else {
      throw Exception('Could not parse discord message string');
    }
  }

  factory DiscordMessage.fromReply(String input) {
    final String? username = '';

    final String? messageContent = RegExp(r"[^AM|PM]*$").stringMatch(input);

    if (username != null && messageContent != null) {
      return DiscordMessage(
        username: username,
        messageContent: messageContent,
      );
    } else {
      throw Exception('Could not parse discord message string');
    }
  }

  @override
  String toString() {
    print('message parsed: $username $messageContent');
    return super.toString();
  }
}

// void main() {
//   String input =
//       """sgniwder — Today at 7:42 PMbooks for everyone!
// """;

//   final f = DiscordMessage.fromString(input);
//   f.toString();
// }
