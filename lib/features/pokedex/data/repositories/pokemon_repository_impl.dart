import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, Pokemon>> getPokemon(String name) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePokemon = await remoteDataSource.getPokemon(name);
        localDataSource.cachePokemon(remotePokemon);
        return Right(remotePokemon);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPokemon = await localDataSource.getLastPokemon();
        return Right(localPokemon);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemon() {
    // TODO: implement getRandomPokemon
    throw UnimplementedError();
  }
}
