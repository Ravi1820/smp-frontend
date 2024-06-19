import 'package:SMP/model/block_model.dart';

class BlockViewModel {
  final BlockModel movie;

  BlockViewModel({required this.movie});

  int get id {
    return movie.id!;
  }

  String get blockName {
    return movie.blockName!;
  }

  String get apartmentName {
    return movie.apartment!.name!;
  }
 
}
