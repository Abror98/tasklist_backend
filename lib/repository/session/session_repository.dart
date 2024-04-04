import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:tasklist_backend/hash_extension.dart';

@visibleForTesting
Map<String, Session> sessionDb = {};

class Session extends Equatable {

  /// constructor
  const Session(
      {
        required this.token,
        required this.userId,
        required this.createdAt,
        required this.expiryDate
      });

  final String token;
  final String userId;
  final DateTime expiryDate;
  final DateTime createdAt;

  @override
  List<Object?> get props => [token, userId, expiryDate, createdAt];
}

/// Session Repository
class SessionRepository{

  /// Create session
  Session createSession(String userId){
    final session = Session(token: generateToken(userId), userId: userId,
        createdAt: DateTime.now(), expiryDate: DateTime.now().add(const Duration(hours: 24)));

    sessionDb[session.token] = session;
    return session;
  }

  /// generate token
  String generateToken(String userId){
    return '${userId}_${DateTime.now().toIso8601String()}'.hashValue;
  }

  /// Search a session of a particular token
 Session? sessionFromToken(String token){
    final session = sessionDb[token];

    if(session != null && session.expiryDate.isAfter(DateTime.now())){
      return session;
    }
    return null;
 }
}