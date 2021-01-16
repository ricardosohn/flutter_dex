part of 'pokedex_bloc.dart';

abstract class PokedexEvent extends Equatable {
  const PokedexEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => props;
}

class GetPokemon extends PokedexEvent {
  final String name;

  GetPokemon(this.name) : super([name]);
}

class GetRandomPokemon extends PokedexEvent {}
