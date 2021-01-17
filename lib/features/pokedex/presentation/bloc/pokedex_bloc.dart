import 'dart:async';

import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/core/usecases/usecase.dart';
import 'package:FlutterDex/core/util/input_converter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_pokemon.dart';
import '../../domain/usecases/get_random_pokemon.dart';

part 'pokedex_event.dart';
part 'pokedex_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid Input - the string can only contain letters";

class PokedexBloc extends Bloc<PokedexEvent, PokedexState> {
  final GetPokemon getPokemon;
  final GetRandomPokemon getRandomPokemon;
  final InputConverter inputConverter;

  PokedexBloc(
      {@required GetPokemon getPokemon,
      @required GetRandomPokemon getRandomPokemon,
      @required InputConverter inputConverter})
      : assert(getPokemon != null),
        assert(getRandomPokemon != null),
        assert(inputConverter != null),
        getPokemon = getPokemon,
        getRandomPokemon = getRandomPokemon,
        inputConverter = inputConverter,
        super(Empty());

  @override
  Stream<PokedexState> mapEventToState(
    PokedexEvent event,
  ) async* {
    if (event is GetPokemonEvent) {
      yield* _handleGetPokemonEvent(event);
    } else if (event is GetRandomPokemonEvent) {
      yield* _handleGetRandomPokemonEvent(event);
    }
  }

  Stream<PokedexState> _handleGetPokemonEvent(event) async* {
    final inputEither = inputConverter.validateString(event.name);
    yield* inputEither.fold((failure) async* {
      yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
    }, (pokemonName) async* {
      yield Loading();
      final failureOrPokemon =
          await getPokemon(Params(pokemonName: pokemonName));
      yield* _eitherLoadedOrErrorState(failureOrPokemon);
    });
  }

  Stream<PokedexState> _handleGetRandomPokemonEvent(event) async* {
    yield Loading();
    final failureOrPokemon = await getRandomPokemon(NoParams());
    yield* _eitherLoadedOrErrorState(failureOrPokemon);
  }

  Stream<PokedexState> _eitherLoadedOrErrorState(
      Either<Failure, Pokemon> failureOrPokemon) async* {
    yield failureOrPokemon.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (pokemon) => Loaded(pokemon: pokemon));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error";
    }
  }
}
