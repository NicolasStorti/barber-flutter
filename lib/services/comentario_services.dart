import 'package:barbearia/models/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComentarioServices {
  String userId;

  ComentarioServices() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String comentarioKey = "comentarios";

  Future<void> AddComentario(
  {required String idAgendamento, required Comentario comentario}) async {
    return await _firestore
        .collection(userId)
        .doc(idAgendamento)
        .collection(comentarioKey)
        .doc(comentario.id)
        .set(comentario.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamComentario(
  {required String idAgendamento}) {
    return _firestore
        .collection(userId)
        .doc(idAgendamento)
        .collection(comentarioKey)
        .orderBy("data", descending: true)
        .snapshots();
  }

  Future<void> removerComentario(
      {required String agendamentoId, required String comentarioId}) async {
    return _firestore
        .collection(userId)
        .doc(agendamentoId)
        .collection(comentarioKey)
        .doc(comentarioId)
        .delete();
  }
}
