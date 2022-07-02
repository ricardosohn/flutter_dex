import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_dex/core/error/exceptions.dart';
import 'package:flutter_dex/core/error/failures.dart';
import 'package:flutter_dex/core/network/network_info.dart';
import 'package:flutter_dex/features/pokedex/data/datasources/pokemon_local_data_source.dart';
import 'package:flutter_dex/features/pokedex/data/datasources/pokemon_remote_data_source.dart';
import 'package:flutter_dex/features/pokedex/data/models/pokemon_model.dart';
import 'package:flutter_dex/features/pokedex/data/repositories/pokemon_repository_impl.dart';
import 'package:flutter_dex/features/pokedex/domain/entities/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements PokemonRemoteDataSource {}

class MockLocalDataSource extends Mock implements PokemonLocalDataSource {}

class MockPokemonModel extends Mock implements PokemonModel {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockRandom extends Mock implements Random {}

void main() {
  late PokemonRepositoryImpl repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockRandom? mockRandom;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockRandom = MockRandom();
    mockNetworkInfo = MockNetworkInfo();
    repository = PokemonRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        random: mockRandom,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getPokemon', () {
    setUp(() {
      registerFallbackValue(MockPokemonModel());
    });

    final tName = "Test";
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
    final Pokemon tPokemon = tPokemonModel;
    test('should test if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource!.getPokemon(any()))
          .thenAnswer((_) async => MockPokemonModel());
      when(() => mockLocalDataSource!.cachePokemon(any()))
          .thenAnswer((_) async {});
      //act
      await repository.getPokemon(tName);
      //assert
      verify(() => mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getPokemon(any()))
            .thenAnswer((_) async => tPokemonModel);
        when(() => mockLocalDataSource!.cachePokemon(tPokemonModel))
            .thenAnswer((_) async {});
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verify(() => mockRemoteDataSource!.getPokemon(tName));
        expect(result, equals(Right(tPokemonModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getPokemon(any()))
            .thenAnswer((_) async => tPokemonModel);
        when(() => mockLocalDataSource!.cachePokemon(tPokemonModel))
            .thenAnswer((_) async {});
        //act
        await repository.getPokemon(tName);
        //assert
        verify(() => mockRemoteDataSource!.getPokemon(tName));
        verify(() => mockLocalDataSource!.cachePokemon(tPokemonModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
        //arrange
        when(() => mockRemoteDataSource!.getPokemon(any()))
            .thenThrow(ServerException());
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verify(() => mockRemoteDataSource!.getPokemon(tName));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cache data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource!.getLastPokemon())
            .thenAnswer((_) async => tPokemonModel);
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource!.getLastPokemon());
        expect(result, Right(tPokemon));
      });
      test(
          'should return cache CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(() => mockLocalDataSource!.getLastPokemon())
            .thenThrow(CacheException());
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource!.getLastPokemon());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomPokemon', () {
    setUp(() {
      registerFallbackValue(MockPokemonModel());
    });

    final tRandomNumber = 131;
    final tPokemonModel = PokemonModel(
        abilities: [],
        baseExperience: 101,
        height: 10,
        id: 132,
        name: "Test",
        order: 11,
        sprites: {},
        stats: [],
        types: [],
        weight: 40);
    test('should test if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => mockRandom!.nextInt(any())).thenReturn(tRandomNumber);
      when(() => mockRemoteDataSource!.getPokemonById(any()))
          .thenAnswer((_) async => MockPokemonModel());
      when(() => mockLocalDataSource!.cachePokemon(any()))
          .thenAnswer((_) async {});
      //act
      await repository.getRandomPokemon();
      //assert
      verify(() => mockNetworkInfo!.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrange
        when(() => mockRandom!.nextInt(any())).thenReturn(tRandomNumber);
        when(() => mockRemoteDataSource!.getPokemonById(tPokemonModel.id))
            .thenAnswer((_) async => tPokemonModel);
        when(() => mockLocalDataSource!.cachePokemon(any()))
            .thenAnswer((_) async {});
        //act
        final result = await repository.getRandomPokemon();
        //assert
        verify(() => mockRandom!.nextInt(any()));
        verify(() => mockRemoteDataSource!.getPokemonById(tPokemonModel.id));
        expect(result, equals(Right(tPokemonModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        //arrange
        when(() => mockRandom!.nextInt(any())).thenReturn(tRandomNumber);
        when(() => mockRemoteDataSource!.getPokemonById(any()))
            .thenAnswer((_) async => tPokemonModel);
        when(() => mockLocalDataSource!.cachePokemon(any()))
            .thenAnswer((_) async {});
        //act
        await repository.getRandomPokemon();
        //assert
        verify(() => mockRandom!.nextInt(any()));
        verify(() => mockRemoteDataSource!.getPokemonById(tPokemonModel.id));
        verify(() => mockLocalDataSource!.cachePokemon(tPokemonModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
        //arrange
        when(() => mockRandom!.nextInt(any())).thenReturn(tRandomNumber);
        when(() => mockRemoteDataSource!.getPokemonById(tPokemonModel.id))
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomPokemon();
        //assert
        verify(() => mockRandom!.nextInt(any()));
        verify(() => mockRemoteDataSource!.getPokemonById(tPokemonModel.id));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
