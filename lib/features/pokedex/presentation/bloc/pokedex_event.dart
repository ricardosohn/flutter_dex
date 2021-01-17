part of 'pokedex_bloc.dart';

abstract class PokedexEvent extends Equatable {
  const PokedexEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => props;
}

class GetPokemonEvent extends PokedexEvent {
  final String name;

  GetPokemonEvent(this.name) : super([name]);
}

class GetRandomPokemonEvent extends PokedexEvent {}
