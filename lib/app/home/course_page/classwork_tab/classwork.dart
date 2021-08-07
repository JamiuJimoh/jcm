import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bool_bloc.dart';

class Classwork extends StatelessWidget {
  // Classwork({required this.boolCubit});
  // final BoolCubit boolCubit;
  static Widget create(context) {
    return BlocProvider<BoolCubit>(
      create: (_) => BoolCubit(),
      child: Classwork(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoolCubit, int>(
      builder: (context, state) {
        return Container(
          height: 500.0,
          width: 500.0,
          color: Colors.green,
          child: Center(
            child: Column(
              children: [
                Text(state.toString(),
                    style: Theme.of(context).textTheme.headline5),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<BoolCubit>().falsify(),
                      child: Text('Falsify'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<BoolCubit>().truthify(),
                      child: Text('truthify'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
