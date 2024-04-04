import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) {

  return switch(context.request.method){
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createLists(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}


Future<Response> _getLists(RequestContext context) async{
  final lists = <Map<String, dynamic>>[];
  final results = await context.read<Connection>().execute('SELECT id, name FROM lists');

  for (final row in results) {
    lists.add({'id': row[0], 'name': row[1]});
  }

  return Response.json(body: lists.toString());
}

Future<Response> _createLists(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if(name != null) {
    try {
    final result = await context.read<Connection>().execute(
          "INSERT INTO lists (name) VALUES (" + "'" + name + "'" + ") ");

      if(result.affectedRows == 1){
       return Response.json(body: {'success': true});
      }
      else {
        return Response.json(body: {'success': false});
      }
    } catch (e) {
      return Response(statusCode: HttpStatus.connectionClosedWithoutResponse);
    }
  } else{
    return Response(statusCode:  HttpStatus.badRequest);
  }

}