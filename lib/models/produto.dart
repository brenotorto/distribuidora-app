class Produto {
  final String id;
  final String? codigoPcms;
  final String codigoBarras;
  final String nome;
  final String descricao;
  final double preco;
  final int estoque;
  final String categoria;
  final String? imagemUrl;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Produto({
    required this.id,
    this.codigoPcms,
    required this.codigoBarras,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.categoria,
    this.imagemUrl,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  factory Produto.fromMap(Map<String, dynamic> map, String id) {
    return Produto(
      id: id,
      codigoPcms: map['codigoPcms'] ?? '',
      codigoBarras: map['codigoBarras'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      estoque: map['estoque'] ?? 0,
      categoria: map['categoria'] ?? '',
      imagemUrl: map['imagemUrl'],
      criadoEm: DateTime.fromMillisecondsSinceEpoch(map['criadoEm'] ?? 0),
      atualizadoEm: DateTime.fromMillisecondsSinceEpoch(map['atualizadoEm'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigoPcms': codigoPcms,
      'codigoBarras': codigoBarras,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'categoria': categoria,
      'imagemUrl': imagemUrl,
      'criadoEm': criadoEm.millisecondsSinceEpoch,
      'atualizadoEm': atualizadoEm.millisecondsSinceEpoch,
    };
  }

  Produto copyWith({
    String? id,
    String? codigoPcms,
    String? codigoBarras,
    String? nome,
    String? descricao,
    double? preco,
    int? estoque,
    String? categoria,
    String? imagemUrl,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Produto(
      id: id ?? this.id,
      codigoPcms: codigoPcms ?? this.codigoPcms,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      estoque: estoque ?? this.estoque,
      categoria: categoria ?? this.categoria,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}