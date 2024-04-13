import 'package:barbearia/models/agendamento.dart';
import 'package:barbearia/components/comendario_dialog.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:flutter/material.dart';

class AgendamentoScreen extends StatelessWidget {
  final Agendamento agendamento;

  AgendamentoScreen({super.key, required this.agendamento});

  final ComentarioServices _comentarioServices = ComentarioServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              agendamento.servico,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogComentario(context, idAgendamento: agendamento.id);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Enviar Foto"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Tirar Foto"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Barbeiro:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.barbeiro),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Data:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.data),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Hora:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.hora),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              const Text(
                "Comentarios:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              StreamBuilder(
                  stream: _comentarioServices.connectStreamComentario(
                      idAgendamento: agendamento.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.docs.isNotEmpty) {
                        final List<Comentario> listaComentarios = [];

                        for (var doc in snapshot.data!.docs) {
                          listaComentarios.add(Comentario.fromMap(doc.data()));
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(listaComentarios.length, (index) {
                            Comentario comentarioAgora =
                                listaComentarios[index];
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(comentarioAgora.comentario),
                              subtitle: Text(comentarioAgora.data),
                              leading: const Icon(Icons.double_arrow),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialogComentario(
                                        context,
                                        idAgendamento: agendamento.id,
                                        comentario: comentarioAgora,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _comentarioServices.removerComentario(
                                          agendamentoId: agendamento.id,
                                          comentarioId: comentarioAgora.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      } else {
                        return const Text("Nenhum Comentário!");
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
