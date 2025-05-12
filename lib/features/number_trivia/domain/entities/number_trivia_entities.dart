import 'package:equatable/equatable.dart';

class NumberTiviaEntities extends Equatable {
  final String text;
  final int number;

  const NumberTiviaEntities({required this.text, required this.number});

  @override
  List<Object?> get props => [text, number];
}
