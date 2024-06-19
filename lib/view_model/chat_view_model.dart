import 'package:SMP/model/chat_model.dart';

class ChatViewModel {
  final ChatModel movie;

  ChatViewModel({required this.movie});

  int get id {
    return movie.senderId!;
  }

  String get senderName {
    return movie.senderName!;
  }
}
