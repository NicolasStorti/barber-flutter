import 'package:barbearia/components/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:flutter/material.dart';
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
                Comentario comentario = Comentario(
                  id: Uuid().v1(),
                  comentario: _comentarioController.text,
                  data: DateTime.now().toString(),
                );
                if (comentario != null) {
                  comentario.id = comentario.id;
                }
                ComentarioServices().AddComentario(idAgendamento: idAgendamento, comentario: comentario);
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
