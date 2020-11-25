import 'package:bel/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/pages_bloc.dart';


class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => PagesBloc()),
        ],
        child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Wrapper()),
        
      );
  }
}