import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_dex/features/pokedex/data/models/pokemon_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

typedef Future<Pokemon> _WithParamOrRandomChooser();
const LAST_POKEMON_ID = 898;

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource? remoteDataSource;
  final PokemonLocalDataSource? localDataSource;
  final Random? random;
  final NetworkInfo? networkInfo;

  PokemonRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.random,
      required this.networkInfo});

  @override
  Future<Either<Failure, Pokemon>> getPokemon(String name) async {
    return await _getPokemon(() {
      return remoteDataSource!.getPokemon(name);
    });
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemon() async {
    int randomId = random!.nextInt(LAST_POKEMON_ID) + 1;
    return await _getPokemon(() {
      return remoteDataSource!.getPokemonById(randomId);
    });
  }

  Future<Either<Failure, Pokemon>> _getPokemon(
      _WithParamOrRandomChooser getWithParamOrRandom) async {
    if (await networkInfo!.isConnected) {
      try {
        final remotePokemon = await getWithParamOrRandom();
        await localDataSource!.cachePokemon(remotePokemon as PokemonModel);
        return Right(remotePokemon);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPokemon = await localDataSource!.getLastPokemon();
        return Right(localPokemon);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
