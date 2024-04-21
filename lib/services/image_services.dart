import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageServices {
  Future<String> enviarFoto(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw e;
    }
  }

}