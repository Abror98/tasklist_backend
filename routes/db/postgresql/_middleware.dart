
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';


Handler middleware(Handler handler) {
   return (context) async{
     
     final connection =  await Connection.open(Endpoint(
         host: 'localhost',
         port: 5432,
         database: 'mytasklists',
         username: 'postgres',
         password: 'abror123',
     ), settings: const ConnectionSettings(sslMode: SslMode.disable));

     final response = await handler.use(provider<Connection>((_) => connection)).call(context);

     await connection.close();

     return response;
   };
}
