import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bool_bloc.dart';

class Classwork extends StatefulWidget {
  Classwork({required this.boolBloc});
  final BoolBloc boolBloc;
  static Widget create(context) {
    return Provider<BoolBloc>(
      create: (_) => BoolBloc(),
      child: Consumer<BoolBloc>(
          builder: (_, boolBloc, __) => Classwork(boolBloc: boolBloc)),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _ClassworkState createState() => _ClassworkState();
}

class _ClassworkState extends State<Classwork> {
  @override
  void dispose() {
    super.dispose();
    widget.boolBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        // initialData: false,

        stream: widget.boolBloc.boolStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            CircularProgressIndicator();
          }
          return Container(
            height: 500.0,
            width: 500.0,
            color: Colors.green,
            child: Center(
              child: Column(
                children: [
                  Text(snapshot.data.toString(),
                      style: Theme.of(context).textTheme.headline5),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.boolBloc.addBoolVal();
                          widget.boolBloc.boolStream
                              .listen((event) => print(event));
                        },
                        child: Text('Falsify'),
                      ),
                      // ElevatedButton(
                      //   onPressed: () => context.read<BoolCubit>().truthify(),
                      //   child: Text('truthify'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
