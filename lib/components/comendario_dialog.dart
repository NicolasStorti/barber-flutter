import 'package:barbearia/components/snackbar.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> showDialogComentario(BuildContext context,
    {required String idAgendamento, Comentario? comentario}) {
  TextEditingController comentarioController = TextEditingController();

  if (comentario != null) {
    comentarioController.text = comentario.comentario;
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
        content: TextFormField(
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