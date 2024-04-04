import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

@visibleForTesting
/// Data source - in-memory cache
Map<String, TaskList> listDb = {};

class TaskList extends Equatable {
  factory TaskList.fromRawJson(String str) =>
      TaskList.fromJson(json.decode(str) as Map<String, dynamic>);

/// Constructor
  const TaskList({
    required this.id,
    required this.name,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
        id: json["id"] as String, // Cast the value to String
        name: json["name"] as String, // Cast the value to String
      );
  final String id;
  final String name;

  TaskList copyWith({
    String? id,
    String? name,
  }) =>
      TaskList(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];
}

class TaskListRepository{


  /// Check in the internal data source for a list with the given id
  Future<TaskList?> listById(String id) async{
    return listDb[id];
  }

  /// Get All the lists from the data source
  Map<String, dynamic> getAllLists(){
    final formattedLists = <String, dynamic>{};
    if(listDb.isNotEmpty){
      listDb.forEach((String id) {
        final currentList = listDb[id];
        formattedLists[id] = currentList?.toJson();

      } as void Function(String key, TaskList value));
    }
    return formattedLists;
  }

  /// Create a new list with a given [name]
  String createList({required String name}){
     final id = name.hashValue;

     final list = TaskList(id: id, name: name);

     listDb[id] = list;

     return id;
  }

  void deleteList(String id){
    listDb.remove(id);
  }

  void updateList({required String id, required String name}) async{
     final currentlist = listDb[id];

     if(currentlist == null){
       return Future.error(Exception('List not found'));
     }

     listDb[id] = TaskList(id: id, name: name);
  }

}
