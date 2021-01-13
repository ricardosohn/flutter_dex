import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Pokemon extends Equatable {
  final List abilities;
  final int baseExperience;
  final double height;
  final int id;
  final String name;
  final int order;
  final Map<String, dynamic> sprites;
  final List stats;
  final List types;
  final double weight;

  Pokemon(
      {@required this.abilities,
      @required this.baseExperience,
      @required this.height,
      @required this.id,
      @required this.name,
      @required this.order,
      @required this.sprites,
      @required this.stats,
      @required this.types,
      @required this.weight});

  @override
  List<Object> get props => [
        abilities,
        baseExperience,
        height,
        id,
        name,
        order,
        sprites,
        stats,
        types,
        weight
      ];
}
