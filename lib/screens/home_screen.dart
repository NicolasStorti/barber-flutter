import 'package:barbearia/models/agendamento.dart';
import 'package:barbearia/components/list_agendamento.dart';
import 'package:barbearia/services/agendamento_services.dart';
import 'package:barbearia/services/auth_services.dart';
import 'package:barbearia/components/agendamento_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AgendamentoServices services = AgendamentoServices();

  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text(
            'Meus Agendamentos',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDecrescente = !isDecrescente;
              });
            },
            icon: const Icon(Icons.compare_arrows_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const  CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                ),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                AuthServices().logoutUser();
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StreamBuilder(
          stream: services.connectStreamAgendamento(isDecrescente),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
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
                    return ListAgendamento(agendamento: agendamento, services: services);
                  }),
                );
              } else {
                return const Center(
                  child: Text("Nenhum Agendamento Encontrado!"),
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalAgendamento(context);
        },
      ),
    );
  }
}
