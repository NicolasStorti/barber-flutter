class Agendamento{
  String id;
  String servico;
  String barbeiro;
  String data;
  String hora;
  String? urlImagem;

  Agendamento({
    required this.id,
    required this.servico,
    required this.barbeiro,
    required this.data,
    required this.hora,
  });

  Agendamento.fromMap(Map<String, dynamic> map):
        id = map["id"],
        servico = map["servico"],
        barbeiro = map["barbeiro"],
        data = map["data"],
        hora = map["hora"],
        urlImagem = map["urlImagem"];

  Map<String,dynamic> toMap(){
    return{
      "id": id,
      "servico": servico,
      "barbeiro": barbeiro,
      "data": data,
      "hora": hora,
      "urlImagem": urlImagem,
    };
  }

}