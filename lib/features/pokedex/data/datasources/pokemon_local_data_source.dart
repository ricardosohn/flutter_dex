import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  /// Gets cached [PokemonModel] which was received the last time user had
  /// an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PokemonModel> getLastPokemon();

  Future<void> cachePokemon(PokemonModel pokemonModel);
}

const CACHED_POKEMON = 'CACHED_POKEMON';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences? sharedPreferences;

  PokemonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PokemonModel> getLastPokemon() {
    final jsonString = sharedPreferences!.getString(CACHED_POKEMON);
    if (jsonString != null) {
      return Future.value(PokemonModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePokemon(PokemonModel pokemonModel) {
    return sharedPreferences!.setString(
        CACHED_POKEMON, json.encode(pokemonModel.toJson()));
  }
}
