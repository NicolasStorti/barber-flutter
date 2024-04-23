import 'dart:io';
import 'package:barbearia/models/agendamento.dart';
import 'package:barbearia/components/comendario_dialog.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:barbearia/services/image_services.dart'; // Importe adicionado para _imageServices
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AgendamentoScreen extends StatefulWidget {
  final Agendamento agendamento;

  const AgendamentoScreen({Key? key, required this.agendamento})
      : super(key: key);

  @override
  _AgendamentoScreenState createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  late File? _imagemEnviada;
  final ComentarioServices _comentarioServices = ComentarioServices();
  final ImageServices _imageServices =
      ImageServices(); // Instância de ImageServices adicionada
  late Stream<QuerySnapshot<Map<String, dynamic>>> _imageStream;

  @override
  void initState() {
    super.initState();
    _imagemEnviada = null;
    _imageStream = _imageServices.connectStreamImages(
        idAgendamento: widget.agendamento.id);
  }

  Future<void> _enviarFoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemEnviada = File(pickedFile.path);
      });

      File imageFile = File(pickedFile.path);
      try {
        String imageUrl = await _imageServices.addImage(
          idAgendamento: widget.agendamento.id,
          imageFile: imageFile,
        );

        print('Imagem enviada com sucesso! URL: $imageUrl');
      } catch (e) {
        print('Erro ao enviar imagem: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.agendamento.servico,
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
          showDialogComentario(context,
              idAgendamento: widget.agendamento.id,
              imageServices: _imageServices);
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
              StreamBuilder(
                stream: _imageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      final imageUrl = snapshot.data!.docs.first['imageUrl'];

                      return imageUrl.isNotEmpty
                          ? Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(imageUrl),
                                ),
                                const SizedBox(height: 20),
                              ],
                            )
                          : const SizedBox();
                    } else {
                      return const SizedBox();
                    }
                  }
                },
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
              Text(widget.agendamento.barbeiro),
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
              Text(widget.agendamento.data),
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
              Text(widget.agendamento.hora),
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
                  idAgendamento: widget.agendamento.id,
                ),
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
                          Comentario comentarioAgora = listaComentarios[index];
                          return SizedBox(
                            width: 300,
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(comentarioAgora.comentario),
                              subtitle: Text(comentarioAgora.data),
                              leading: const Icon(Icons.mode_comment),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialogComentario(
                                        context,
                                        idAgendamento: widget.agendamento.id,
                                        comentario: comentarioAgora, imageServices: _imageServices,
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
                                      SnackBar snackBar = SnackBar(
                                        content: Text(
                                            "Deseja remover o comentário de ${comentarioAgora.comentario}?"),
                                        action: SnackBarAction(
                                          label: "Remover",
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _comentarioServices
                                                .removerComentario(
                                              agendamentoId:
                                                  widget.agendamento.id,
                                              comentarioId: comentarioAgora.id,
                                            );
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Text("Nenhum Comentário!");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
