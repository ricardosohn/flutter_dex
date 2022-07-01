part of 'pokedex_bloc.dart';

abstract class PokedexState extends Equatable {
  const PokedexState();

  @override
  List<Object> get props => [];
}

class Empty extends PokedexState {}

class Loading extends PokedexState {}

class Loaded extends PokedexState {
  final Pokemon pokemon;

  Loaded({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class Error extends PokedexState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
