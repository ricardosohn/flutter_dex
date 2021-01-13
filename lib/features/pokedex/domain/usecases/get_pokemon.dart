import 'package:FlutterDex/features/pokedex/domain/entities/Pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:FlutterDex/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetPokemon {
  final PokemonRepository repository;

  GetPokemon(this.repository);

  Future<Either<Failure, Pokemon>> call({@required String pokemonName}) async {
    return await repository.getPokemon(pokemonName);
  }
}
