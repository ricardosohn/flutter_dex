import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/pokedex/data/datasources/pokemon_local_data_source.dart';
import 'features/pokedex/data/datasources/pokemon_remote_data_source.dart';
import 'features/pokedex/data/repositories/pokemon_repository_impl.dart';
import 'features/pokedex/domain/repositories/pokemon_repository.dart';
import 'features/pokedex/domain/usecases/get_pokemon.dart';
import 'features/pokedex/domain/usecases/get_random_pokemon.dart';
import 'features/pokedex/presentation/bloc/pokedex_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Pokedex
  // Bloc
  sl.registerFactory(() => PokedexBloc(
      getPokemon: sl(), getRandomPokemon: sl(), inputConverter: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetPokemon(sl()));
  sl.registerLazySingleton(() => GetRandomPokemon(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      random: sl(),
      networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PokemonLocalDataSource>(
      () => PokemonLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
