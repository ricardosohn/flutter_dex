import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/Pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tPokemonModel = PokemonModel(
      abilities: [],
      baseExperience: 101,
      height: 10,
      id: 1,
      name: "Test",
      order: 11,
      sprites: {},
      stats: [],
      types: [],
      weight: 40);

  test('should be a subclass of Pokemon entity', () async {
    //assert
    expect(tPokemonModel, isA<Pokemon>());
  });
}
