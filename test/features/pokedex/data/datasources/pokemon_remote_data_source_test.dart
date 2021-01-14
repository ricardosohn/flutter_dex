import 'package:FlutterDex/core/error/exceptions.dart';
import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/core/platform/network_info.dart';
import 'package:FlutterDex/features/pokedex/data/datasources/pokemon_local_data_source.dart';
import 'package:FlutterDex/features/pokedex/data/datasources/pokemon_remote_data_source.dart';
import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';
import 'package:FlutterDex/features/pokedex/data/repositories/pokemon_repository_impl.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements PokemonRemoteDataSource {}

class MockLocalDataSource extends Mock implements PokemonLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  PokemonRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PokemonRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getPokemon', () {
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
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getPokemon(tName);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getPokemon(any))
            .thenAnswer((_) async => tPokemonModel);
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verify(mockRemoteDataSource.getPokemon(tName));
        expect(result, equals(Right(tPokemonModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getPokemon(any))
            .thenAnswer((_) async => tPokemonModel);
        //act
        await repository.getPokemon(tName);
        //assert
        verify(mockRemoteDataSource.getPokemon(tName));
        verify(mockLocalDataSource.cachePokemon(tPokemonModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
        //arrange
        when(mockRemoteDataSource.getPokemon(any)).thenThrow(ServerException());
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verify(mockRemoteDataSource.getPokemon(tName));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cache data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastPokemon())
            .thenAnswer((_) async => tPokemonModel);
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastPokemon());
        expect(result, Right(tPokemon));
      });
      test(
          'should return cache CacheFailure when there is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastPokemon()).thenThrow(CacheException());
        //act
        final result = await repository.getPokemon(tName);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastPokemon());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
