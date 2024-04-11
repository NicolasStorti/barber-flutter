import 'package:barbearia/components/agendamento.dart';
import 'package:barbearia/components/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendamentoServices {
  String userId;

  AgendamentoServices() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAgendamento(Agendamento agendamento) async {
    return await _firestore
        .collection(userId)
        .doc(agendamento.id)
        .set(agendamento.toMap());
  }

  Future<void> AddComentario(
      String idAgendamento, Comentario comentario) async {
    return await _firestore
        .collection(userId)
        .doc(idAgendamento)
        .collection("comentarios")
        .doc(comentario.id)
        .set(comentario.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamAgendamento(bool isDecrescente){
    return _firestore.collection(userId).orderBy("servico", descending: isDecrescente).snapshots();
  }

  Future<void> removerAgendamento({required String idAgendamento}){
    return _firestore.collection(userId).doc(idAgendamento).delete();
  }
}
