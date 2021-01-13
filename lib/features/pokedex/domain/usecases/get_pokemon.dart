import 'package:FlutterDex/core/usecases/usecase.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:FlutterDex/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
