import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bool_bloc.dart';
import 'bottom_sheet_content.dart';

class Classwork extends StatefulWidget {
  const Classwork({
    Key? key,
    required this.boolBloc,
  }) : super(key: key);
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
  Future<void> _buildModalBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      context: context,
      builder: (_) => const BottomSheetContent(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.boolBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _buildModalBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
