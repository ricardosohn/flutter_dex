import 'package:dartz/dartz.dart';
import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  @override
  Future<Either<Failure, Pokemon>> getPokemon(String name) {
    // TODO: implement getPokemon
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemon() {
    // TODO: implement getRandomPokemon
    throw UnimplementedError();
  }
}
