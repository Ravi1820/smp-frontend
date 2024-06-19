class Flat {
  final int id;
  final int floorId;
  final String name;

  Flat({
    required this.id,
    required this.floorId,
    required this.name,
  });

  factory Flat.fromJson(Map<String, dynamic> json) {
    return Flat(
      id: json['id'],
      floorId: json['floor_id'],
      name: json['name'],
    );
  }
}

class Floor {
  final int id;
  final int blockId;
  final String name;
  final List<Flat> flats;

  Floor({
    required this.id,
    required this.blockId,
    required this.name,
    required this.flats,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    var flatList = json['flat'] as List;
    List<Flat> flats = flatList.map((flat) => Flat.fromJson(flat)).toList();

    return Floor(
      id: json['id'],
      blockId: json['block_id'],
      name: json['name'],
      flats: flats,
    );
  }
}

class Block {
  final int id;
  final String name;
  final List<Floor> floors;

  Block({
    required this.id,
    required this.name,
    required this.floors,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    var floorList = json['floor'] as List;
    List<Floor> floors = floorList.map((floor) => Floor.fromJson(floor)).toList();

    return Block(
      id: json['id'],
      name: json['block'],
      floors: floors,
    );
  }
}
