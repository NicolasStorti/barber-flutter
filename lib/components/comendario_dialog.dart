import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:barbearia/components/snackbar.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:barbearia/services/image_services.dart';

Future<dynamic> showDialogComentario(BuildContext context,
    {required String idAgendamento, Comentario? comentario, required ImageServices imageServices}) {
  TextEditingController comentarioController = TextEditingController();

  Future<void> _enviarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {

      File imageFile = File(pickedFile.path);
      try {
        String imageUrl = await imageServices.addImage(
          idAgendamento: idAgendamento,
          imageFile: imageFile,
        );

        print('Imagem enviada com sucesso! URL: $imageUrl');
        Navigator.pop(context);
      } catch (e) {
        print('Erro ao enviar imagem: $e');
      }
    }
  }

  Future<void> _tirarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {

      File imageFile = File(pickedFile.path);
      try {
        String imageUrl = await imageServices.addImage(
          idAgendamento: idAgendamento,
          imageFile: imageFile,
        );

        print('Imagem tirada com sucesso! URL: $imageUrl');
        Navigator.pop(context);
      } catch (e) {
        print('Erro ao tirar imagem: $e');
      }
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Comente agora sobre seu agendamento!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: comentarioController,
              decoration: const InputDecoration(
                labelText: 'Comentário',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um comentário.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Você deseja enviar ou tirar uma foto?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _enviarFoto,
                      child: const Text("Enviar Foto"),
                    ),
                    ElevatedButton(
                      onPressed: _tirarFoto,
                      child: const Text("Tirar Foto"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (comentarioController.text.isNotEmpty) {
                String comentarioId = comentario?.id ?? const Uuid().v1();
                String comentarioData =
                DateFormat('dd MMMM yyyy').format(DateTime.now());
                Comentario novoComentario = Comentario(
                  id: comentarioId,
                  comentario: comentarioController.text,
                  data: comentario?.data ?? comentarioData,
                );

                ComentarioServices().addComentario(
                  idAgendamento: idAgendamento,
                  comentario: novoComentario,
                ).then((_) {
                  showSnackbar(
                    context: context,
                    text: (comentario != null)
                        ? 'Comentário editado com sucesso!'
                        : 'Comentário adicionado com sucesso!',
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  showSnackbar(
                    context: context,
                    text: 'Erro ao adicionar o comentário.',
                  );
                });
              } else {
                showSnackbar(
                  context: context,
                  text: 'Por favor, insira um comentário.',
                );
              }
            },
            child: Text(
              (comentario != null) ? "Editar" : "Comentar",
            ),
          ),
        ],
      );
    },
  );
}