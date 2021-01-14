import 'package:FlutterDex/features/pokedex/data/models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  /// Gets cached [PokemonModel] which was received the last time user had
  /// an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PokemonModel> getLastPokemon();

  Future<void> cachePokemon(PokemonModel pokemonModel);
}
