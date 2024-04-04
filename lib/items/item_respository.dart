import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

@visibleForTesting

/// Data source - in-memory cache
Map<String, TaskItem> itemDb = {};

class TaskItem extends Equatable {
  final String id;
  final String listid;
  final String name;
  final String desciption;
  final bool status;

  TaskItem({
    required this.id,
    required this.listid,
    required this.name,
    required this.desciption,
    required this.status,
  });

  TaskItem copyWith({
    String? id,
    String? listid,
    String? name,
    String? desciption,
    bool? status,
  }) =>
      TaskItem(
        id: id ?? this.id,
        listid: listid ?? this.listid,
        name: name ?? this.name,
        desciption: desciption ?? this.desciption,
        status: status ?? this.status,
      );

  String toRawJson() => json.encode(toJson());

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json["id"] as String,
        listid: json["listid"] as String,
        name: json["name"] as String,
        desciption: json["desciption"] as String,
        status: json["status"] as bool,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "listid": listid,
        "name": name,
        "desciption": desciption,
        "status": status,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id, listid, name, desciption, name, status];
}

class TaskItemRepository {
  /// Check in the internal data source for a list with the given id
  Future<TaskItem?> listById(String id) async {
    return itemDb[id];
  }

  /// Get All the lists from the data source
  Map<String, dynamic> getAllItems() {
    final formattedLists = <String, dynamic>{};
    if (itemDb.isNotEmpty) {
      itemDb.forEach((String id) {
        final currentList = itemDb[id];
        formattedLists[id] = currentList?.toJson();
      } as void Function(String key, TaskItem value));
    }
    return formattedLists;
  }

  /// Create a new list with a given [name]
  String createItem(
      {required String listid,
      required String name,
      required String desciption,
      required bool status}) {
    final id = name.hashValue;

    final item = TaskItem(
        id: id,
        name: name,
        listid: listid,
        desciption: desciption,
        status: status);

    itemDb[id] = item;

    return id;
  }

  void deleteList(String id) {
    itemDb.remove(id);
  }

  void updateList(
      {required String id,
      required String name,
      required String listid,
      required String desciption,
      required bool status}) async {
    final currentitem = itemDb[id];

    if (currentitem == null) {
      return Future.error(Exception('List not found'));
    }

    itemDb[id] = TaskItem(id: id, name: name, listid: listid, desciption: desciption, status: status);
  }
}
