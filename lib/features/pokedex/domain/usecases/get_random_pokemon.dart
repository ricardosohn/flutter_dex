import 'package:FlutterDex/core/usecases/usecase.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/Pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:FlutterDex/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetRandomPokemon implements Usecase<Pokemon, NoParams> {
  final PokemonRepository repository;

  GetRandomPokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(NoParams params) async {
    return await repository.getRandomPokemon();
  }
}
