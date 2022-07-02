import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dex/core/error/failures.dart';
import 'package:flutter_dex/core/usecases/usecase.dart';
import 'package:flutter_dex/core/util/input_converter.dart';
import 'package:flutter_dex/features/pokedex/domain/entities/pokemon.dart';
import 'package:flutter_dex/features/pokedex/domain/usecases/get_pokemon.dart';
import 'package:flutter_dex/features/pokedex/domain/usecases/get_random_pokemon.dart';
import 'package:flutter_dex/features/pokedex/presentation/bloc/pokedex_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPokemon extends Mock implements GetPokemon {}

class MockGetRandomPokemon extends Mock implements GetRandomPokemon {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late PokedexBloc pokedexBloc;
  late MockGetPokemon mockGetPokemon;
  late MockGetRandomPokemon mockGetRandomPokemon;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetPokemon = MockGetPokemon();
    mockGetRandomPokemon = MockGetRandomPokemon();
    mockInputConverter = MockInputConverter();
    pokedexBloc = PokedexBloc(
        getPokemon: mockGetPokemon,
        getRandomPokemon: mockGetRandomPokemon,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    expect(pokedexBloc.state, Empty());
  });

  group('getPokemon', () {
    final tName = "Test";
    final tPokemon = Pokemon(
        abilities: [],
        id: 1,
        baseExperience: 100,
        height: 100,
        order: 130,
        weight: 130,
        stats: [],
        name: "Test",
        types: [],
        sprites: {});

    PokedexBloc buildPokedexBloc() => PokedexBloc(
        getPokemon: mockGetPokemon,
        getRandomPokemon: mockGetRandomPokemon,
        inputConverter: mockInputConverter);

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.validateString(any()))
            .thenReturn(Right(tName));

    void setUpMockInputConverterFailure() =>
        when(() => mockInputConverter.validateString(any()))
            .thenReturn(Left(InputConverterFailure()));

    blocTest(
      'should call the InputConverter to validate the name string',
      build: () {
        setUpMockInputConverterFailure();
        return buildPokedexBloc();
      },
      act: (dynamic bloc) async => await bloc.add(GetPokemonEvent(tName)),
      verify: (dynamic _) {
        mockInputConverter.validateString(tName);
      },
    );

    blocTest(
      'should emit [Error] when the input is invalid',
      build: () {
        setUpMockInputConverterFailure();
        return buildPokedexBloc();
      },
      act: (dynamic bloc) => bloc.add(GetPokemonEvent(tName)),
      expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    blocTest('should get data from the getPokemon usecase',
        setUp: () {
          setUpMockInputConverterSuccess();
          when(() => mockGetPokemon(Params(pokemonName: tName)))
              .thenAnswer((_) async => Right(tPokemon));
        },
        build: () => buildPokedexBloc(),
        act: (dynamic bloc) => bloc.add(GetPokemonEvent(tName)),
        verify: (dynamic _) {
          mockGetPokemon(Params(pokemonName: tName));
        });

    blocTest(
        'should emit [Loading] and [Loaded] when data is gotten successfully',
        setUp: () {
          setUpMockInputConverterSuccess();
          when(() => mockGetPokemon(Params(pokemonName: tName)))
              .thenAnswer((_) async => Right(tPokemon));
        },
        build: () => buildPokedexBloc(),
        act: (dynamic bloc) async => await bloc.add(GetPokemonEvent(tName)),
        expect: () => [Loading(), Loaded(pokemon: tPokemon)]);

    blocTest(
      'should emit [Loading] and [Error] when data fails',
      setUp: () {
        setUpMockInputConverterSuccess();
        when(() => mockGetPokemon(Params(pokemonName: tName)))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => buildPokedexBloc(),
      act: (dynamic bloc) => bloc.add(GetPokemonEvent(tName)),
      expect: () => [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest(
      '''should emit [Loading] and [Error] with a proper message for the 
        error when getting data fails''',
      setUp: () {
        setUpMockInputConverterSuccess();
        when(() => mockGetPokemon(Params(pokemonName: tName)))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => buildPokedexBloc(),
      act: (dynamic bloc) => bloc.add(GetPokemonEvent(tName)),
      expect: () => [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });

  group('getRandomPokemon', () {
    final tPokemon = Pokemon(
        abilities: [],
        id: 1,
        baseExperience: 100,
        height: 100,
        order: 130,
        weight: 130,
        stats: [],
        name: "Test",
        types: [],
        sprites: {});

    PokedexBloc buildPokedexBloc() => PokedexBloc(
        getPokemon: mockGetPokemon,
        getRandomPokemon: mockGetRandomPokemon,
        inputConverter: mockInputConverter);
    blocTest('should get data from the getRandomPokemon usecase',
        setUp: () {
          when(() => mockGetRandomPokemon(NoParams()))
              .thenAnswer((_) async => Right(tPokemon));
        },
        build: () => buildPokedexBloc(),
        act: (dynamic bloc) => bloc.add(GetRandomPokemonEvent()),
        verify: (dynamic _) {
          mockGetRandomPokemon(NoParams());
        });

    blocTest(
      'should emit [Loading] and [Loaded] when data is gotten successfully',
      setUp: () {
        when(() => mockGetRandomPokemon(NoParams()))
            .thenAnswer((_) async => Right(tPokemon));
      },
      build: () => buildPokedexBloc(),
      act: (dynamic bloc) => bloc.add(GetRandomPokemonEvent()),
      expect: () => [Loading(), Loaded(pokemon: tPokemon)],
    );

    blocTest(
      'should emit [Loading] and [Error] when data fails',
      setUp: () {
        when(() => mockGetRandomPokemon(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => buildPokedexBloc(),
      act: (dynamic bloc) => bloc.add(GetRandomPokemonEvent()),
      expect: () => [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );

    blocTest(
      '''should emit [Loading] and [Error] with a proper message for the 
        error when getting data fails''',
      setUp: () {
        when(() => mockGetRandomPokemon(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => buildPokedexBloc(),
      act: (dynamic bloc) => bloc.add(GetRandomPokemonEvent()),
      expect: () => [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
