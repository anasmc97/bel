part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();
}

class GoToMainPage extends PagesEvent {
  @override
  List<Object> get props => [];
}

class GoToHariPage extends PagesEvent {
   String hari;
  GoToHariPage({this.hari});
  @override
  List<Object> get props => [];
}
