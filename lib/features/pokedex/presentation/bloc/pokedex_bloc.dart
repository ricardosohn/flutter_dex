import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/core/usecases/usecase.dart';
import 'package:FlutterDex/core/util/input_converter.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

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

  PokedexBloc({
    required GetPokemon getPokemon,
    required GetRandomPokemon getRandomPokemon,
    required InputConverter inputConverter,
  })  : getPokemon = getPokemon,
        getRandomPokemon = getRandomPokemon,
        inputConverter = inputConverter,
        super(Empty()) {
    on<GetPokemonEvent>((event, emit) async {
      final inputEither = inputConverter.validateString(event.name!);
      if (inputEither.isRight()) {
        emit(Loading());
        final pokemonName = inputEither.getOrElse(() => "");
        final either = await getPokemon(Params(pokemonName: pokemonName));
        emit(_eitherLoadedOrErrorState(either));
      } else {
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }
    });

    on<GetRandomPokemonEvent>((event, emit) async {
      emit(Loading());
      final either = await getRandomPokemon(NoParams());
      emit(_eitherLoadedOrErrorState(either));
    });
  }

  PokedexState _eitherLoadedOrErrorState(
      Either<Failure, Pokemon> failureOrPokemon) {
    return failureOrPokemon.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (pokemon) => Loaded(pokemon: pokemon),
    );
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
