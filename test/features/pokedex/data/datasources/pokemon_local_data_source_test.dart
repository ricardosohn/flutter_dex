import 'dart:convert';

import 'package:FlutterDex/core/error/exceptions.dart';
import 'package:FlutterDex/features/pokedex/data/datasources/pokemon_local_data_source.dart';
import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixtures_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  PokemonLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        PokemonLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastPokemon', () {
    final tPokemonModel =
        PokemonModel.fromJson(json.decode(fixture('pokemon_cached.json')));
    test(
        'should return Pokemon from SharedPreferences when there is one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('pokemon_cached.json'));
      //act
      final result = await dataSource.getLastPokemon();
      //assert
      verify(mockSharedPreferences.getString(CACHED_POKEMON));
      expect(result, equals(tPokemonModel));
    });
    test('should throw [CacheException] when there is not a cached value',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastPokemon;
      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cachePokemon', () {
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
    test('should call SharedPreferences to cache the data', () async {
      //act
      dataSource.cachePokemon(tPokemonModel);
      //assert
      final expectedJsonString = json.encode(tPokemonModel.toJson());
      verify(
          mockSharedPreferences.setString(CACHED_POKEMON, expectedJsonString));
    });
  });
}
