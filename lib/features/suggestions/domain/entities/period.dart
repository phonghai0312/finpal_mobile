import 'package:equatable/equatable.dart';

class Period extends Equatable {
  final int from;
  final int to;

  const Period({required this.from, required this.to});

  @override
  List<Object?> get props => [from, to];

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      from: json['from'] as int,
      to: json['to'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}
