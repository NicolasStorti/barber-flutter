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
        TextEditingController _comentarioController = TextEditingController();

        if (comentario != null) {
          _comentarioController.text = comentario.comentario;
        }

        return AlertDialog(
          title: Text("Comente agora sobre seu agendamento!"),
          content: TextFormField(
            controller: _comentarioController,
            decoration: InputDecoration(
              label: Text("Comentário"),
              border: OutlineInputBorder(),
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                String comentarioId = comentario?.id ?? Uuid().v1();
                String comentarioData = DateFormat('dd MMMM yyyy').format(DateTime.now());
                Comentario novoComentario = Comentario(
                  id: comentarioId,
                  comentario: _comentarioController.text,
                  data: comentario?.data ?? comentarioData,
                );

                ComentarioServices().AddComentario(
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
