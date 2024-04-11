import 'package:barbearia/components/agendamento.dart';
import 'package:barbearia/services/agendamento_services.dart';
import 'package:barbearia/services/auth_services.dart';
import 'package:barbearia/components/modal_agendamento.dart';
import 'package:barbearia/screens/agendamento_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AgendamentoServices services = AgendamentoServices();

  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Agendamentos'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDecrescente = !isDecrescente;
              });
            },
            icon: Icon(Icons.sort_by_alpha_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/perfil.jpg"),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              onTap: () {
                AuthServices().LogoutUser();
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: services.connectStreamAgendamento(isDecrescente),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<Agendamento> listaAgendamento = [];
              for (var doc in snapshot.data!.docs) {
                listaAgendamento.add(Agendamento.fromMap(doc.data()));
              }
              return ListView(
                children: List.generate(listaAgendamento.length, (index) {
                  Agendamento agendamento = listaAgendamento[index];
                  return ListTile(
                    title: Text(agendamento.servico),
                    subtitle: Text(
                        "Hora: ${agendamento.hora} - Data: ${agendamento.data}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            ShowModalAgendamento(context,
                                agendamento: agendamento);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                  "Deseja remover o agendamento de ${agendamento.servico}?"),
                              action: SnackBarAction(
                                label: "Remover",
                                textColor: Colors.white,
                                onPressed: () {
                                  services.removerAgendamento(
                                      idAgendamento: agendamento.id);
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgendamentoScreen(
                            agendamento: agendamento,
                          ),
                        ),
                      );
                    },
                  );
                }),
              );
            } else {
              return Center(
                child: Text("Nenhum Agendamento Encontrado!"),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ShowModalAgendamento(context);
        },
      ),
    );
  }
}
