import 'package:FlutterDex/features/pokedex/domain/entities/pokemon.dart';
import 'package:FlutterDex/features/pokedex/presentation/bloc/pokedex_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PokedexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pokedex app"),
        ),
        body: _buildBody(context));
  }
}

BlocProvider<PokedexBloc> _buildBody(BuildContext context) {
  return BlocProvider(
    create: (context) => GetIt.instance<PokedexBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          BlocBuilder<PokedexBloc, PokedexState>(builder: (context, state) {
            if (state is Empty) {
              return MessageDisplay(message: "Start searching");
            } else if (state is Error) {
              return MessageDisplay(message: state.message);
            } else if (state is Loading) {
              return CircularProgressIndicator();
            } else if (state is Loaded) {
              return PokedexEntry(pokemon: state.pokemon);
            } else {
              return MessageDisplay(message: "Unexpected Event");
            }
          }),
          SizedBox(
            height: 20,
          ),
          PokedexControl()
        ]),
      ),
    ),
  );
}

class PokedexControl extends StatefulWidget {
  @override
  PokedexControlState createState() => PokedexControlState();
}

class PokedexControlState extends State<PokedexControl> {
  String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Search Pokemon by name'),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                child: Text("Search"),
                color: Colors.green[600],
                onPressed: () => dispatchGetPokemon(context),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text("Random"),
                color: Colors.yellow[600],
                onPressed: () => dispatchGetRandomPokemon(context),
              ),
            )
          ],
        )
      ],
    );
  }

  void dispatchGetPokemon(BuildContext context) {
    BlocProvider.of<PokedexBloc>(context).add(GetPokemonEvent(inputStr));
  }

  void dispatchGetRandomPokemon(BuildContext context) {
    BlocProvider.of<PokedexBloc>(context).add(GetRandomPokemonEvent());
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Text(
        message,
        style: TextStyle(fontSize: 25.0),
      ),
    );
  }
}

class PokedexEntry extends StatelessWidget {
  final Pokemon pokemon;

  const PokedexEntry({Key key, @required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(children: [
          Text(pokemon.name,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          Image.network(pokemon.sprites["front_default"])
        ]));
  }
}
