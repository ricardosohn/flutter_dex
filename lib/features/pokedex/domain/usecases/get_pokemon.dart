import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemon implements Usecase<Pokemon, Params> {
  final PokemonRepository repository;

  GetPokemon(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(Params params) async {
    return await repository.getPokemon(params.pokemonName);
  }
}

class Params extends Equatable {
  final String pokemonName;

  Params({@required this.pokemonName});

  @override
  List<Object> get props => [pokemonName];
}
