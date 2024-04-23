class Imagem {
  String id;
  String imagem;
  String data;

  Imagem({
    required this.id,
    required this.imagem,
    required this.data
  });

  Imagem.fromMap(Map<String, dynamic> map):
        id = map["id"],
        imagem = map["comentario"],
        data = map["data"];

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "comentario": imagem,
      "data": data,
    };
  }
}