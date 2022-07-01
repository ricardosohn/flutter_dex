import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/{name} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getPokemon(String name);

  /// Calls the https://pokeapi.co/api/v2/pokemon/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getPokemonById(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client? client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getPokemon(String name) =>
      _getPokemonFromUrl('https://pokeapi.co/api/v2/pokemon/$name');

  @override
  Future<PokemonModel> getPokemonById(int id) =>
      _getPokemonFromUrl('https://pokeapi.co/api/v2/pokemon/$id');

  Future<PokemonModel> _getPokemonFromUrl(url) async {
    final response = await client!
        .get(Uri.parse(url), headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      return PokemonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
