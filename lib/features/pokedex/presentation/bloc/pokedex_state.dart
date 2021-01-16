part of 'pokedex_bloc.dart';

abstract class PokedexState extends Equatable {
  const PokedexState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => props;
}

class Empty extends PokedexState {}

class Loading extends PokedexState {}

class Loaded extends PokedexState {
  final Pokemon pokemon;

  Loaded({@required this.pokemon}) : super([pokemon]);
}

class Error extends PokedexState {
  final String message;

  Error({@required this.message}) : super([message]);
}
