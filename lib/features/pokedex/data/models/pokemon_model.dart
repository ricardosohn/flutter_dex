import 'package:meta/meta.dart';
import '../../domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel(
      {@required List abilities,
      @required int baseExperience,
      @required double height,
      @required int id,
      @required String name,
      @required int order,
      @required Map<String, dynamic> sprites,
      @required List stats,
      @required List types,
      @required double weight})
      : super(
            abilities: abilities,
            baseExperience: baseExperience,
            height: height,
            id: id,
            name: name,
            order: order,
            sprites: sprites,
            stats: stats,
            types: types,
            weight: weight);

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
        abilities: json['abilities'] as List,
        baseExperience: (json['base_experience'] as num).toInt(),
        height: (json['height'] as num).toDouble(),
        id: json['id'] as int,
        name: json['name'] as String,
        order: json['order'] as int,
        sprites: json['sprites'] as Map<String, dynamic>,
        stats: json['stats'] as List,
        types: json['types'] as List,
        weight: (json['weight'] as num).toDouble());
  }

  Map<String, dynamic> toJson() => {
        'abilities': this.abilities,
        'base_experience': this.baseExperience,
        'height': this.height,
        'id': this.id,
        'name': this.name,
        'order': this.order,
        'sprites': this.sprites,
        'stats': this.stats,
        'types': this.types,
        'weight': this.weight
      };
}
