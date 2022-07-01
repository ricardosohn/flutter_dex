import 'package:FlutterDex/core/error/failures.dart';
import 'package:FlutterDex/core/usecases/usecase.dart';
import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:FlutterDex/features/pokedex/domain/usecases/get_random_pokemon.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late GetRandomPokemon usecase;
  MockPokemonRepository? mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetRandomPokemon(mockPokemonRepository);
  });

  final pData = Pokemon(
      abilities: [],
      baseExperience: 101,
      height: 10,
      id: 1,
      name: "Test",
      order: 11,
      sprites: {},
      stats: [],
      types: [],
      weight: 40);

  test('should get pokemon data from the repository', () async {
    //arrange
    when(() => mockPokemonRepository!.getRandomPokemon())
        .thenAnswer((_) async => Right(pData));
    //act
    final Either<Failure, Pokemon>? result = await usecase(NoParams());
    //assert
    expect(result, Right(pData));
    verify(() => mockPokemonRepository!.getRandomPokemon());
    verifyNoMoreInteractions(mockPokemonRepository);
  });
}
