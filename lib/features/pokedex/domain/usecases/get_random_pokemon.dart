import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetRandomPokemon implements Usecase<Pokemon, NoParams> {
  final PokemonRepository? repository;

  GetRandomPokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(NoParams params) async {
    return await repository!.getRandomPokemon();
  }
}
