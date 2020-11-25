import 'package:bel/hari.dart';
import 'package:bel/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/pages_bloc.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Bloc Builder <PagesBloc --> Bloc yang Digunakan , PagesState --> merupakan State yang dihasilkan dari mapEventToState
    return BlocBuilder<PagesBloc, PagesState>(
        builder: (_, pageState) => (pageState
                is OnHariPage) //pagestate merupakan class
            ? Home(pageState.hari)
            : (pageState is OnMainPage)
                ? MainPage() : Container()); //
  }
}
