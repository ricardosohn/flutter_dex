import 'package:meta/meta.dart';
import '../../domain/entities/Pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel(
      {@required List abilities,
      @required int baseExperience,
      @required num height,
      @required int id,
      @required String name,
      @required int order,
      @required Map<String, dynamic> sprites,
      @required List stats,
      @required List types,
      @required num weight});

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
        abilities: json['abilities'] as List,
        baseExperience: json['base_experience'] as num,
        height: json['height'] as num,
        id: json['id'] as num,
        name: json['name'] as String,
        order: json['order'] as num,
        sprites: json['sprites'] as Map<String, dynamic>,
        stats: json['stats'] as List,
        types: json['types'] as List,
        weight: json['weight'] as num);
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
