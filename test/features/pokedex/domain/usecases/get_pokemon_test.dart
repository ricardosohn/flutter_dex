import 'package:FlutterDex/features/pokedex/domain/entities/Pokemon.dart';
import 'package:FlutterDex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:FlutterDex/features/pokedex/domain/usecases/get_pokemon.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  GetPokemon usecase;
  MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetPokemon(mockPokemonRepository);
  });

  final pName = "Test";
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

  test('should get pokemon data for the pokemon name from the repository',
      () async {
    //arrange
    when(mockPokemonRepository.getPokemon(any))
        .thenAnswer((_) async => Right(pData));
    //act
    final result = await usecase(Params(pokemonName: pName));
    //assert
    expect(result, Right(pData));
    verify(mockPokemonRepository.getPokemon(pName));
    verifyNoMoreInteractions(mockPokemonRepository);
  });
}
