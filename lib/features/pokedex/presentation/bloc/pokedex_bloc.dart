import 'dart:async';

import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'pokedex_event.dart';
part 'pokedex_state.dart';

class PokedexBloc extends Bloc<PokedexEvent, PokedexState> {
  PokedexBloc() : super(Empty());

  @override
  Stream<PokedexState> mapEventToState(
    PokedexEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
