import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(requestLogger())
  .use(provider<String>((context) => 'Dart frog tutorial 2023'));
}
