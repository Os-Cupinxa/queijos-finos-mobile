class AgendaItem {
  
  AgendaItem({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.tipo,
  });

  // Método para converter JSON em um objeto AgendaItem
  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    return AgendaItem(
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      data: json['data'] as String,
      tipo: json['tipo'] as String,
    );
  }
  final String nome;
  final String descricao;
  final String data;
  final String tipo;
}
