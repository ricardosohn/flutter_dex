import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:dartz/dartz.dart';

abstract class PokemonRepository {
  Future<Either<Failure, Pokemon>> getPokemon(String name);
  Future<Either<Failure, Pokemon>> getRandomPokemon();

  //TBD: The remote API does not provide a ready-to-use method to do this
  // Future<Either<Failure, List<Pokemon>>> getAllPokemonData();
}
