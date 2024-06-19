import 'package:SMP/model/vote_model.dart';
 
class VoteViewModel {
  final VoteModel movie;
  VoteViewModel({required this.movie});
  int get value {
    return movie.id;
  }

  String get name {
    return movie.voteFor;
  }

  bool? get isChecked {
    return movie.isChecked;
  }

  String get responseMsg {
    return movie.responseMsg;
  }

  bool get voted {
    return movie.voted;
  }

  bool isVoted(String responseMsg) {
    print("voted === $voted  this responsemsg ==${this.responseMsg} responsemessage==$responseMsg");
    bool isVoted = (voted && this.responseMsg == responseMsg);
    print("is voted value===$isVoted");
    return isVoted;
  }

  List<String> get formattedOptions {
    final List<String> optionStrings =
        movie.options.map((option) => option).toList();
    return optionStrings;
  }

  DateTime get endDate {
    return movie.endDate;
  }

  DateTime get startDate {
    return movie.startDate;
  }
}
