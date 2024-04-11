import 'package:barbearia/components/agendamento.dart';
import 'package:barbearia/components/modal_agendamento.dart';
import 'package:barbearia/screens/agendamento_screen.dart';
import 'package:barbearia/services/agendamento_services.dart';
import 'package:flutter/material.dart';

class ListAgendamento extends StatelessWidget {
  final Agendamento agendamento;
  final AgendamentoServices services;

  const ListAgendamento(
      {super.key, required this.agendamento, required this.services});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black.withAlpha(125),
              spreadRadius: 1,
              offset: Offset(2, 2),
            )
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22)),
                ),
                height: 40,
                width: 300,
                child: Center(
                  child: Text(
                    "Data: ${agendamento.data} - Hora: ${agendamento.hora}",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          agendamento.servico,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          "Barbeiro: ${agendamento.barbeiro}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
