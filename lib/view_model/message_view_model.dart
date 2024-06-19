import 'package:SMP/model/issue_list_model.dart';
import 'package:SMP/model/message_model.dart';

class MessageViewModel {
  final MessageModel movie;

  MessageViewModel({required this.movie});
 
  int get id {
    return movie.id;
  }

  int get senderId {
    return movie.senderId;
  }

 int get receiverId {
    return movie.receiverId;
  }


  String get message {
    return movie.message;
  }

 
}
