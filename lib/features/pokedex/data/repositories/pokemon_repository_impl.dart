import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

typedef Future<Pokemon> _WithParamOrRandomChooser();

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
    return await _getPokemon(() {
      return remoteDataSource.getPokemon(name);
    });
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemon() async {
    return await _getPokemon(() {
      return remoteDataSource.getRandomPokemon();
    });
  }

  Future<Either<Failure, Pokemon>> _getPokemon(
      _WithParamOrRandomChooser getWithParamOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePokemon = await getWithParamOrRandom();
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
}
