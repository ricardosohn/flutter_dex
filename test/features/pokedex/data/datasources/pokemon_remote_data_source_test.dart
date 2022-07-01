import 'dart:convert';

import 'package:FlutterDex/core/error/exceptions.dart';
import 'package:FlutterDex/features/pokedex/data/datasources/pokemon_remote_data_source.dart';
import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../core/fixtures/fixtures_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Mock implements Uri {}

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  MockHttpClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = PokemonRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(FakeUri());
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient!.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('pokemon.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient!.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getPokemon', () {
    final tPokemonName = "Test";
    final tPokemonModel =
        PokemonModel.fromJson(json.decode(fixture('pokemon.json')));

    test(
        '''should perform a GET request on a URL with the name being the endpoint 
      and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      await dataSource.getPokemon(tPokemonName);
      //assert
      verify(
        () => mockHttpClient!.get(
          Uri.parse('https://pokeapi.co/api/v2/pokemon/$tPokemonName'),
          headers: {'content-type': 'application/json'},
        ),
      );
    });

    test('should return a Pokemon when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getPokemon(tPokemonName);
      //assert
      expect(result, equals(tPokemonModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getPokemon;
      //assert
      expect(() => call(tPokemonName), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomPokemon', () {
    final tPokemonId = 131;
    final tPokemonModel =
        PokemonModel.fromJson(json.decode(fixture('pokemon.json')));

    test(
        '''should perform a GET request on a URL with number being the endpoint 
      and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getPokemonById(tPokemonId);
      //assert
      verify(
        () => mockHttpClient!.get(
          Uri.parse('https://pokeapi.co/api/v2/pokemon/$tPokemonId'),
          headers: {'content-type': 'application/json'},
        ),
      );
    });

    test('should return a Pokemon when the response code is 200 (success)',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getPokemonById(tPokemonId);
      //assert
      expect(result, equals(tPokemonModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = dataSource.getPokemonById;
      //assert
      expect(() => call(tPokemonId), throwsA(isA<ServerException>()));
    });
  });
}
