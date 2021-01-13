import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/Pokemon.dart';
import 'package:dartz/dartz.dart';

abstract class PokemonRepository {
  Future<Either<Failure, Pokemon>> getPokemon(String name);
  Future<Either<Failure, Pokemon>> getRandomPokemon();
  Future<Either<Failure, List<Pokemon>>> getAllPokemonData();
}
