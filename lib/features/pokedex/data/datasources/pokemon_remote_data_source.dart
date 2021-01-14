import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/{name} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getPokemon(String name);

  /// Calls the https://pokeapi.co/api/v2/pokemon/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getRandomPokemon();
}
