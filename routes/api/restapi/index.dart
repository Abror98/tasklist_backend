
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async{
  return switch(context.request.method){
    HttpMethod.get => _getRecipes(context),
   _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getRecipes(RequestContext context) async {
   final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'), headers: {
     'Content-Type': 'application/json'
   });

   if(response.statusCode == 200){
     return Response.json(body: response.body);
   }
   else{
     return Response(statusCode: HttpStatus.badRequest);
   }
}
