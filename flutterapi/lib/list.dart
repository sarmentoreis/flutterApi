class Lista {
  String? nome;
  String? data;

  Lista({
    this.nome,
    this.data,
  });

  Lista.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['data'] = data;
    return data;
  }
}