class Comentario {
  String id;
  String comentario;
  String data;

  Comentario({
    required this.id,
    required this.comentario,
    required this.data
  });

  Comentario.fromMap(Map<String, dynamic> map):
        id = map["id"],
        comentario = map["comentario"],
        data = map["data"];

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "comentario": comentario,
      "data": comentario,
    };
  }
}