import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageServices {
  String userId;

  ImageServices() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  static String imageKey = "imagens";

  Future<String> addImage({required String idAgendamento, required File imageFile}) async {
    final ref = _storage.ref().child('$userId/$imageKey/$idAgendamento/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = ref.putFile(imageFile);

    final TaskSnapshot taskSnapshot = await uploadTask;

    final imageUrl = await taskSnapshot.ref.getDownloadURL();

    await saveImageUrl(idAgendamento, imageUrl);

    return imageUrl;
  }

  Future<void> saveImageUrl(String idAgendamento, String imageUrl) async {
    final ref = FirebaseFirestore.instance
        .collection(userId)
        .doc(idAgendamento)
        .collection(imageKey)
        .doc();

    await ref.set({'imageUrl': imageUrl});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamImages({required String idAgendamento}) {
    return FirebaseFirestore.instance
        .collection(userId)
        .doc(idAgendamento)
        .collection(imageKey)
        .snapshots();
  }

  Future<void> removerImage({required String agendamentoId, required String imageId}) async {
    return FirebaseFirestore.instance
        .collection(userId)
        .doc(agendamentoId)
        .collection(imageKey)
        .doc(imageId)
        .delete();
  }
}