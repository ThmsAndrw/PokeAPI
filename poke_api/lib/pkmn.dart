class Pkmn {
  int id;
  String name;
  int weight;
  int height;

  Pkmn(this.id, this.name, this.weight, this.height);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'height': height
    };
  }
}
