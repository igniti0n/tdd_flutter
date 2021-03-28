import 'package:flutter/material.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class TriviaPage extends StatelessWidget {
  const TriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (context) => sl<NumberTriviaBloc>(),
        child: Builder(
            builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildBody(ctx),
                )),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              bloc: BlocProvider.of<NumberTriviaBloc>(context, listen: false),
              builder: (ctx, state) {
                print("state: $state");
                if (state is Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is Loaded) {
                  return Column(
                    children: [
                      Text(state.trivia.number.toString()),
                      Text(state.trivia.text),
                    ],
                  );
                } else if (state is Error) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return Container();
              },
            ),
          ),
          InputWidget(),
        ],
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  InputWidget({Key? key}) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late final TextEditingController _textEditingController;

  String inputNumber = "";

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(); //.fromValue(TextEditingValue());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textEditingController,
          onChanged: (text) => inputNumber = text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _textEditingController.clear();
                  BlocProvider.of<NumberTriviaBloc>(context, listen: false)
                      .add(GetTriviaForConcreteNumber(inputNumber));
                },
                child: Text('Get Concrete'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _textEditingController.clear();
                  BlocProvider.of<NumberTriviaBloc>(context, listen: false)
                      .add(GetTriviaForRandomNumber());
                },
                child: Text('Get Random'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
