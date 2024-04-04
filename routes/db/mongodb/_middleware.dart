

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return (context) async{
    final db = await Db.create('mongodb+srv://Abror:abror123@atlascluster.br2h2xz.mongodb.net/?retryWrites=true&w=majority&task_list=AtlasCluster');

    if(!db.isConnected){
     await db.open();
    }
    final response = await handler.use(provider<Db>((_) => db)).call(context);

    await db.close();

    return response;
  };
}
