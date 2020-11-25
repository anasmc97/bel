part of 'pages_bloc.dart';

abstract class PagesState extends Equatable {
  const PagesState();
}

class OnMainPage extends PagesState {
  @override
  List<Object> get props => [];
}

class OnHariPage extends PagesState {
  String hari;
  OnHariPage({this.hari});
  @override
  List<Object> get props => [];
}
