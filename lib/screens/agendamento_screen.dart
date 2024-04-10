import 'package:barbearia/components/agendamento.dart';
import 'package:barbearia/components/comentario.dart';
import 'package:barbearia/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AgendamentoScreen extends StatelessWidget {
  final Agendamento agendamento;
  AgendamentoScreen({Key? key, required this.agendamento}) : super(key: key);

  final List<Comentario> listaComentarios = [
    Comentario(id: "01", comentario: "Muito bom", data: "20/10/2024"),
    Comentario(id: "02", comentario: "Detalhes impecáveis", data: "20/10/2024"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              agendamento.servico,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(22),),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
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
                      child: Text("Enviar Foto"),
                    ),
                    ElevatedButton(
                      onPressed: (){},
                      child: Text("Tirar Foto"),),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Barbeiro:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.barbeiro),
              SizedBox(
                height: 10,
              ),
              Text(
                "Data:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.data),
              SizedBox(
                height: 10,
              ),
              Text(
                "Hora:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(agendamento.hora),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Text(
                "Comentarios:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(listaComentarios.length, (index) {
                  Comentario comentarioAgora = listaComentarios[index];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(comentarioAgora.comentario),
                    subtitle: Text(comentarioAgora.data),
                    leading: Icon(Icons.double_arrow),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
