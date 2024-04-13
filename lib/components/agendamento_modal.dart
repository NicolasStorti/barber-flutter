import 'package:barbearia/models/agendamento.dart';
import 'package:barbearia/models/comentario.dart';
import 'package:barbearia/services/agendamento_services.dart';
import 'package:barbearia/services/comentario_services.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

showModalAgendamento(BuildContext context, {Agendamento? agendamento}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AgendamentoModal(
              agendamento: agendamento,
            ),
          ),
        );
      });
}

class AgendamentoModal extends StatefulWidget {
  final Agendamento? agendamento;

  const AgendamentoModal({super.key, this.agendamento});

  @override
  State<AgendamentoModal> createState() => _AgendamentoModalState();
}

class _AgendamentoModalState extends State<AgendamentoModal> {
  final TextEditingController _servicoController = TextEditingController();
  final TextEditingController _barbeiroController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  bool isCarregando = false;

  final AgendamentoServices _agendamentoServices = AgendamentoServices();

  @override
  void initState() {
    if (widget.agendamento != null) {
      _servicoController.text = widget.agendamento!.servico;
      _barbeiroController.text = widget.agendamento!.barbeiro;
      _horaController.text = widget.agendamento!.hora;
      _dataController.text = widget.agendamento!.data;
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('dd MMMM yyyy').format(picked);
        _dataController.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _horaController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          (widget.agendamento != null)
                              ? "Editar ${widget.agendamento!.servico}"
                              : "Agendar um Horário",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _barbeiroController,
                        decoration: const InputDecoration(
                            labelText: 'Barbeiro', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _servicoController,
                        decoration: const InputDecoration(
                            labelText: 'Serviço', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dataController,
                              decoration: const InputDecoration(
                                labelText: 'Data',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _horaController,
                              decoration: const InputDecoration(
                                labelText: 'Hora',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _selectTime(context),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (widget.agendamento == null),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              controller: _comentarioController,
                              decoration: const InputDecoration(
                                  labelText: 'Comentario',
                                  border: OutlineInputBorder()),
                            ),
                            const Text(
                              "Não é necessario comentar agora!",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  agendarHorario();
                },
                child: (isCarregando)
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : Text((widget.agendamento != null)
                        ? "Editar Agendamento"
                        : "Agendar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  agendarHorario() {
    String barbeiro = _barbeiroController.text;
    String servico = _servicoController.text;
    String data = _dataController.text;
    String hora = _horaController.text;
    String comentario = _comentarioController.text;

    setState(() {
      isCarregando = true;
    });

    if (widget.agendamento != null) {
      widget.agendamento!.servico = servico;
      widget.agendamento!.barbeiro = barbeiro;
      widget.agendamento!.data = data;
      widget.agendamento!.hora = hora;

      _agendamentoServices.addAgendamento(widget.agendamento!).then((value) {
        if (comentario.isNotEmpty) {
          Comentario comentarioObj = Comentario(
            id: const Uuid().v1(),
            comentario: comentario,
            data: DateTime.now().toString(),
          );
          ComentarioServices().addComentario(idAgendamento: widget.agendamento!.id, comentario: comentarioObj)
              .then((value) {
            setState(() {
              isCarregando = false;
            });
            Navigator.pop(context);
          });
        } else {
          setState(() {
            isCarregando = false;
          });
          Navigator.pop(context);
        }
      });
    } else {
      Agendamento agendamento = Agendamento(
        id: const Uuid().v1(),
        servico: servico,
        barbeiro: barbeiro,
        data: data,
        hora: hora,
      );

      _agendamentoServices.addAgendamento(agendamento).then((value) {
        if (comentario.isNotEmpty) {
          Comentario comentarioObj = Comentario(
            id: const Uuid().v1(),
            comentario: comentario,
            data: DateFormat('dd MMMM yyyy').format(DateTime.now(),
          ));
          ComentarioServices().addComentario(idAgendamento: agendamento.id, comentario: comentarioObj)
              .then((value) {
            setState(() {
              isCarregando = false;
            });
            Navigator.pop(context);
          });
        } else {
          setState(() {
            isCarregando = false;
          });
          Navigator.pop(context);
        }
      });
    }
  }

}
