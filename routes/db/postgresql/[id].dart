import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:test/expect.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async{

  return switch(context.request.method){
    HttpMethod.patch => _updateLists(context, id),
    HttpMethod.delete => _deleteLists(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _updateLists(RequestContext context, String id) async{
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if(name != null) {
    try {
      final result = await context.read<Connection>().execute(
          "UPDATE lists SET name = " + "'" + name + " '");

      if (result.affectedRows == 1) {
        return Response.json(body: {'success': true});
      } else {
        return Response.json(body: {'success': false});
      }
    } catch (e) {
       return Response(statusCode: HttpStatus.connectionClosedWithoutResponse);
    }
  } else{
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _deleteLists(RequestContext context, String id) async{
  await context.read<Connection>().execute("DELETE FROM lists WHERE id = " + "'" + id + "'").then((value){
    return Response(statusCode: HttpStatus.noContent);
  },
  onError: (e){
    return Response(statusCode: HttpStatus.badRequest);
  }
  );

  return Response(statusCode: HttpStatus.badRequest);
}
