import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  const Currency({required this.code, required this.name});

  final String code;
  final String name;

  @override
  List<Object> get props => [code, name];
}
