import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/core/util/input_converter.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/usecases/get_pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/usecases/get_random_pokemon.dart';
import 'package:FlutterDex/features/pokedex/presentation/bloc/pokedex_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetPokemon extends Mock implements GetPokemon {}

class MockGetRandomPokemon extends Mock implements GetRandomPokemon {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  PokedexBloc pokedexBloc;
  MockGetPokemon mockGetPokemon;
  MockGetRandomPokemon mockGetRandomPokemon;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetPokemon = MockGetPokemon();
    mockGetRandomPokemon = MockGetRandomPokemon();
    mockInputConverter = MockInputConverter();
    pokedexBloc = PokedexBloc(
        getPokemon: mockGetPokemon,
        getRandomPokemon: mockGetRandomPokemon,
        inputConverter: mockInputConverter);
  });

  group('Bloc parameters assertion errors', () {
    test('throws AssertionError if getPokemon usecase is null', () {
      expect(
        () => PokedexBloc(
            getPokemon: null,
            getRandomPokemon: mockGetRandomPokemon,
            inputConverter: mockInputConverter),
        throwsA(isAssertionError),
      );
    });
    test('throws AssertionError if getRandomPokemon usecase is null', () {
      expect(
        () => PokedexBloc(
            getPokemon: mockGetPokemon,
            getRandomPokemon: null,
            inputConverter: mockInputConverter),
        throwsA(isAssertionError),
      );
    });
    test('throws AssertionError if inputConverter is null', () {
      expect(
        () => PokedexBloc(
            getPokemon: mockGetPokemon,
            getRandomPokemon: mockGetRandomPokemon,
            inputConverter: null),
        throwsA(isAssertionError),
      );
    });
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
        when(mockInputConverter.validateString(any)).thenReturn(Right(tName));

    void setUpMockInputConverterFailure() =>
        when(mockInputConverter.validateString(any))
            .thenReturn(Left(InputConverterFailure()));

    blocTest('should call the InputConverter to validate the name string',
        build: () {
          setUpMockInputConverterFailure();
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        verify: (_) {
          mockInputConverter.validateString(tName);
        });

    blocTest('should emit [Error] when the input is invalid',
        build: () {
          setUpMockInputConverterFailure();
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        expect: [Error(message: INVALID_INPUT_FAILURE_MESSAGE)]);

    blocTest('should get data from the getPokemon usecase',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetPokemon(any)).thenAnswer((_) async => Right(tPokemon));
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        verify: (_) {
          mockGetPokemon(Params(pokemonName: tName));
        });

    blocTest(
        'should emit [Loading] and [Loaded] when data is gotten successfully',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetPokemon(any)).thenAnswer((_) async => Right(tPokemon));
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        expect: [Loading(), Loaded(pokemon: tPokemon)]);

    blocTest('should emit [Loading] and [Error] when data fails',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetPokemon(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        expect: [Loading(), Error(message: SERVER_FAILURE_MESSAGE)]);

    blocTest(
        '''should emit [Loading] and [Error] with a proper message for the 
        error when getting data fails''',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetPokemon(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          return buildPokedexBloc();
        },
        act: (bloc) => bloc.add(GetPokemonEvent(tName)),
        expect: [Loading(), Error(message: CACHE_FAILURE_MESSAGE)]);
  });
}
