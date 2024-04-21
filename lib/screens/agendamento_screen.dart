import 'package:barbearia/models/agendamento.dart';
import 'package:barbearia/components/comendario_dialog.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:barbearia/services/image_services.dart';

class AgendamentoScreen extends StatefulWidget {
  final Agendamento agendamento;

  AgendamentoScreen({Key? key, required this.agendamento}) : super(key: key);

  @override
  _AgendamentoScreenState createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  File? _imagemEnviada;

  final ComentarioServices _comentarioServices = ComentarioServices();
  final ImageServices _imageServices = ImageServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _enviarFoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemEnviada = File(pickedFile.path);
      });

      File imageFile = File(pickedFile.path);
      try {
        String imageUrl = await _imageServices.enviarFoto(imageFile);

        String? userId = FirebaseAuth.instance.currentUser?.uid;

        await _firestore.collection('imagens').add({
          'url': imageUrl,
          'userId': userId,
        });

        print('Imagem enviada com sucesso! URL: $imageUrl');
      } catch (e) {
        print('Erro ao enviar imagem: $e');
      }
    }
  }

  Future<void> _tirarFoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagemEnviada = File(pickedFile.path);
      });

      File imageFile = File(pickedFile.path);
      try {
        String imageUrl = await _imageServices.enviarFoto(imageFile);

        String? userId = FirebaseAuth.instance.currentUser?.uid;

        await _firestore.collection('imagens').add({
          'url': imageUrl,
          'userId': userId,
        });

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
          showDialogComentario(context, idAgendamento: widget.agendamento.id);
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
                    // Exibir a imagem enviada pelo usuário, se existir
                    _imagemEnviada != null
                        ? Image.file(_imagemEnviada!, width: 100, height: 100) // Supondo que _imagemEnviada seja o File da imagem enviada
                        : Container(), // Se nenhuma imagem foi enviada, mostrar um container vazio
                    // Verificar se não há imagem enviada e exibir os botões de acordo
                    if (_imagemEnviada == null)
                      ElevatedButton(
                        onPressed: () => _enviarFoto(context),
                        child: const Text("Enviar Foto"),
                      ),
                    if (_imagemEnviada == null)
                      ElevatedButton(
                        onPressed: () => _tirarFoto(context),
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
                      idAgendamento: widget.agendamento.id),
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
                                        idAgendamento: widget.agendamento.id,
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
                                              comentarioId:
                                              comentarioAgora.id,
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
                            );
                          }),
                        );
                      } else {
                        return const Text("Nenhum Comentário!");
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}