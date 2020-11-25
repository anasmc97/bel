import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  PagesBloc() : super(OnMainPage());

  @override
  Stream<PagesState> mapEventToState(
    PagesEvent event,
  ) async* {
    if(event is GoToHariPage){
      yield OnHariPage(hari: event.hari);
    }
    else if(event is GoToMainPage){
      yield OnMainPage();
    }
  }
}
