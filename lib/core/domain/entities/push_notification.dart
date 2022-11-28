import 'package:equatable/equatable.dart';

class PushNotification extends Equatable{
  final String title;
  final String body;
  final int requestId;
  const PushNotification({
    required this.title, 
    required this.body, 
    required this.requestId
  });
  @override
  List<Object?> get props => [
    title,
    body,
    requestId
  ];
}