import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> showDialogComentario(BuildContext context,
    {required String idAgendamento, Comentario? comentario}) {
  return showDialog(
      context: context,
      builder: (context) {
        TextEditingController comentarioController = TextEditingController();

        if (comentario != null) {
          comentarioController.text = comentario.comentario;
        }

        return AlertDialog(
          title: const Text(
            "Comente agora sobre seu agendamento!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          content: TextFormField(
            controller: comentarioController,
            decoration: const InputDecoration(
              label: Text("Comentário"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
            ),
            maxLines: null,
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
                String comentarioId = comentario?.id ?? const Uuid().v1();
                String comentarioData = DateFormat('dd MMMM yyyy').format(DateTime.now());
                Comentario novoComentario = Comentario(
                  id: comentarioId,
                  comentario: comentarioController.text,
                  data: comentario?.data ?? comentarioData,
                );

                ComentarioServices().addComentario(
                  idAgendamento: idAgendamento,
                  comentario: novoComentario,
                );
                Navigator.pop(context);
              },
              child: Text(
                (comentario != null) ? "Editar" : "Comentar",
              ),
            ),
          ],
        );
      });
}
