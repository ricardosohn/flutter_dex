import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import '../../../core/fixtures/fixtures_reader.dart';

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

  group('fromJSON', () {
    test('should return a valid model when the height and weight are integers',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('pokemon.json'));
      //act
      final result = PokemonModel.fromJson(jsonMap);
      //assert
      expect(result, tPokemonModel);
    });
    test('should return a valid model when the height and weight are double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('pokemon_double.json'));
      //act
      final result = PokemonModel.fromJson(jsonMap);
      //assert
      expect(result, tPokemonModel);
    });
  });

  group('toJSON', () {
    test('should return a JSON map containing the proper data', () async {
      //act
      final result = tPokemonModel.toJson();
      //assert
      final expectedMap = {
        "abilities": [],
        "base_experience": 101,
        "height": 10,
        "order": 11,
        "id": 1,
        "name": "Test",
        "sprites": {},
        "stats": [],
        "types": [],
        "weight": 40
      };
      expect(result, expectedMap);
    });
  });
}
