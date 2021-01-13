import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Pokemon extends Equatable {
  final List abilities;
  final num baseExperience;
  final List forms;
  final List gameIndices;
  final num height;
  final List heldItems;
  final num id;
  final bool isDefault;
  final String locationAreaEncounters;
  final List moves;
  final String name;
  final num order;
  final Map<String, dynamic> species;
  final Map<String, dynamic> sprites;
  final List stats;
  final List types;
  final num weight;

  Pokemon(
      {@required this.abilities,
      @required this.baseExperience,
      @required this.forms,
      @required this.gameIndices,
      @required this.height,
      @required this.heldItems,
      @required this.id,
      @required this.isDefault,
      @required this.locationAreaEncounters,
      @required this.moves,
      @required this.name,
      @required this.order,
      @required this.species,
      @required this.sprites,
      @required this.stats,
      @required this.types,
      @required this.weight});

  @override
  List<Object> get props => [
        abilities,
        baseExperience,
        forms,
        gameIndices,
        height,
        heldItems,
        id,
        isDefault,
        locationAreaEncounters,
        moves,
        name,
        order,
        species,
        sprites,
        stats,
        types,
        weight
      ];
}
