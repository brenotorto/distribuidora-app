import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';

class ImportacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> importarProdutosPDF() async {
    // Lista de produtos do PDF https://www.coad.com.br/imagensMat/247839a.pdf
    final produtos = [
      // CERVEJAS
      {'codigoBarras': '7891149000104', 'nome': 'Skol Lata 350ml', 'descricao': 'Cerveja Skol Pilsen Lata 350ml', 'preco': 3.50, 'estoque': 120, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000203', 'nome': 'Brahma Lata 350ml', 'descricao': 'Cerveja Brahma Chopp Lata 350ml', 'preco': 3.80, 'estoque': 100, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000302', 'nome': 'Antarctica Original 350ml', 'descricao': 'Cerveja Antarctica Original Lata', 'preco': 4.20, 'estoque': 80, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000401', 'nome': 'Bohemia Lata 350ml', 'descricao': 'Cerveja Bohemia Pilsen Premium', 'preco': 5.50, 'estoque': 60, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000500', 'nome': 'Stella Artois 330ml', 'descricao': 'Cerveja Stella Artois Long Neck', 'preco': 6.80, 'estoque': 45, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000609', 'nome': 'Heineken Lata 350ml', 'descricao': 'Cerveja Heineken Premium Lager', 'preco': 7.50, 'estoque': 40, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000708', 'nome': 'Corona Extra 330ml', 'descricao': 'Cerveja Corona Extra Long Neck', 'preco': 8.90, 'estoque': 30, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000807', 'nome': 'Budweiser Lata 350ml', 'descricao': 'Cerveja Budweiser American Lager', 'preco': 6.20, 'estoque': 50, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149000906', 'nome': 'Eisenbahn Pilsen 355ml', 'descricao': 'Cerveja Eisenbahn Pilsen Long Neck', 'preco': 9.50, 'estoque': 25, 'categoria': 'Cervejas'},
      {'codigoBarras': '7891149001005', 'nome': 'Original Lata 350ml', 'descricao': 'Cerveja Original Premium Lager', 'preco': 4.80, 'estoque': 70, 'categoria': 'Cervejas'},
      
      // BEBIDAS
      {'codigoBarras': '7891000100103', 'nome': 'Coca-Cola Lata 350ml', 'descricao': 'Refrigerante Coca-Cola Original', 'preco': 4.50, 'estoque': 50, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891000053508', 'nome': 'Fanta Laranja Lata 350ml', 'descricao': 'Refrigerante Fanta Sabor Laranja', 'preco': 4.00, 'estoque': 40, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891000244807', 'nome': 'Sprite Lata 350ml', 'descricao': 'Refrigerante Sprite Lima-Limão', 'preco': 4.00, 'estoque': 35, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891991010924', 'nome': 'Guaraná Antarctica 350ml', 'descricao': 'Refrigerante Guaraná Antarctica', 'preco': 4.25, 'estoque': 45, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891000315507', 'nome': 'Água Crystal 500ml', 'descricao': 'Água Mineral Natural Crystal', 'preco': 2.50, 'estoque': 100, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891991004213', 'nome': 'Sukita Laranja 350ml', 'descricao': 'Refrigerante Sukita Sabor Laranja', 'preco': 3.80, 'estoque': 30, 'categoria': 'Bebidas'},
      {'codigoBarras': '7891000130100', 'nome': 'Schweppes Citrus 350ml', 'descricao': 'Refrigerante Schweppes Citrus', 'preco': 4.75, 'estoque': 25, 'categoria': 'Bebidas'},
      
      // LATICÍNIOS
      {'codigoBarras': '7891000244203', 'nome': 'Leite Ninho Integral 400g', 'descricao': 'Leite em Pó Integral Nestlé Ninho', 'preco': 18.90, 'estoque': 20, 'categoria': 'Laticínios'},
      {'codigoBarras': '7891000105108', 'nome': 'Leite Moça Lata 395g', 'descricao': 'Leite Condensado Nestlé Moça', 'preco': 8.50, 'estoque': 35, 'categoria': 'Laticínios'},
      {'codigoBarras': '7891000053201', 'nome': 'Creme de Leite Nestlé 200g', 'descricao': 'Creme de Leite UHT Nestlé', 'preco': 4.20, 'estoque': 40, 'categoria': 'Laticínios'},
      {'codigoBarras': '7891000100004', 'nome': 'Iogurte Nestlé Morango 170g', 'descricao': 'Iogurte Natural Sabor Morango', 'preco': 3.50, 'estoque': 60, 'categoria': 'Laticínios'},
      
      // BISCOITOS E DOCES
      {'codigoBarras': '7896036094853', 'nome': 'Biscoito Trakinas Morango', 'descricao': 'Biscoito Recheado Trakinas Morango', 'preco': 3.75, 'estoque': 60, 'categoria': 'Biscoitos'},
      {'codigoBarras': '7622210951045', 'nome': 'Chocolate KitKat 41.5g', 'descricao': 'Chocolate ao Leite KitKat Nestlé', 'preco': 5.50, 'estoque': 35, 'categoria': 'Doces'},
      {'codigoBarras': '7896036098745', 'nome': 'Biscoito Passatempo Recheado', 'descricao': 'Biscoito Passatempo Chocolate', 'preco': 4.25, 'estoque': 45, 'categoria': 'Biscoitos'},
      {'codigoBarras': '7891000100707', 'nome': 'Chocolate Butterfinger', 'descricao': 'Chocolate Butterfinger Nestlé', 'preco': 6.80, 'estoque': 25, 'categoria': 'Doces'},
      {'codigoBarras': '7896273201045', 'nome': 'Biscoito Cream Cracker Adria', 'descricao': 'Biscoito Salgado Cream Cracker', 'preco': 2.90, 'estoque': 80, 'categoria': 'Biscoitos'},
      
      // GRÃOS E CEREAIS
      {'codigoBarras': '7891118014507', 'nome': 'Arroz Tio João Tipo 1 - 1kg', 'descricao': 'Arroz Branco Polido Tipo 1', 'preco': 6.80, 'estoque': 80, 'categoria': 'Grãos'},
      {'codigoBarras': '7891118025503', 'nome': 'Feijão Tio João Preto 1kg', 'descricao': 'Feijão Preto Tipo 1 Tio João', 'preco': 8.50, 'estoque': 45, 'categoria': 'Grãos'},
      {'codigoBarras': '7891118026507', 'nome': 'Feijão Tio João Carioca 1kg', 'descricao': 'Feijão Carioca Tipo 1 Tio João', 'preco': 7.90, 'estoque': 50, 'categoria': 'Grãos'},
      {'codigoBarras': '7891000053102', 'nome': 'Aveia Nestlé Flocos 200g', 'descricao': 'Aveia em Flocos Nestlé Fitness', 'preco': 5.40, 'estoque': 30, 'categoria': 'Cereais'},
      
      // HIGIENE E LIMPEZA
      {'codigoBarras': '7891024130100', 'nome': 'Sabonete Dove Original 90g', 'descricao': 'Sabonete Hidratante Dove', 'preco': 3.20, 'estoque': 70, 'categoria': 'Higiene'},
      {'codigoBarras': '7891150056404', 'nome': 'Shampoo Seda Reconstrução', 'descricao': 'Shampoo Seda Reconstrução 325ml', 'preco': 12.90, 'estoque': 25, 'categoria': 'Higiene'},
      {'codigoBarras': '7891024128701', 'nome': 'Desodorante Rexona Men 150ml', 'descricao': 'Desodorante Aerosol Rexona Men', 'preco': 8.75, 'estoque': 40, 'categoria': 'Higiene'},
      {'codigoBarras': '7891150047105', 'nome': 'Detergente Ypê Neutro 500ml', 'descricao': 'Detergente Líquido Neutro Ypê', 'preco': 2.10, 'estoque': 90, 'categoria': 'Limpeza'},
      
      // MASSAS E MOLHOS
      {'codigoBarras': '7896036098201', 'nome': 'Macarrão Adria Espaguete 500g', 'descricao': 'Massa Espaguete Adria Grano Duro', 'preco': 4.60, 'estoque': 55, 'categoria': 'Massas'},
      {'codigoBarras': '7891000100806', 'nome': 'Molho de Tomate Nestlé 340g', 'descricao': 'Molho de Tomate Tradicional', 'preco': 3.80, 'estoque': 65, 'categoria': 'Molhos'},
      {'codigoBarras': '7896273200704', 'nome': 'Macarrão Adria Penne 500g', 'descricao': 'Massa Penne Rigate Adria', 'preco': 4.90, 'estoque': 40, 'categoria': 'Massas'},
      
      // TEMPEROS E CONDIMENTOS
      {'codigoBarras': '7891000053805', 'nome': 'Maggi Caldo de Galinha', 'descricao': 'Tempero Maggi Caldo de Galinha', 'preco': 1.50, 'estoque': 120, 'categoria': 'Temperos'},
      {'codigoBarras': '7891000100509', 'nome': 'Maggi Fundor 100g', 'descricao': 'Tempero Completo Maggi Fundor', 'preco': 4.30, 'estoque': 75, 'categoria': 'Temperos'},
      {'codigoBarras': '7891118020105', 'nome': 'Sal Refinado Cisne 1kg', 'descricao': 'Sal de Cozinha Refinado Especial', 'preco': 2.20, 'estoque': 100, 'categoria': 'Temperos'},
      
      // ÓLEOS E AZEITES
      {'codigoBarras': '7891118026203', 'nome': 'Óleo de Soja Soya 900ml', 'descricao': 'Óleo de Soja Refinado Soya', 'preco': 7.50, 'estoque': 60, 'categoria': 'Óleos'},
      {'codigoBarras': '7896036097403', 'nome': 'Azeite Andorinha Extra Virgem', 'descricao': 'Azeite Extra Virgem 500ml', 'preco': 15.90, 'estoque': 20, 'categoria': 'Óleos'},
      
      // ENLATADOS
      {'codigoBarras': '7891000100201', 'nome': 'Sardinha Gomes da Costa 125g', 'descricao': 'Sardinha em Óleo Comestível', 'preco': 4.80, 'estoque': 85, 'categoria': 'Enlatados'},
      {'codigoBarras': '7891000053904', 'nome': 'Atum Gomes da Costa 170g', 'descricao': 'Atum Sólido em Óleo Comestível', 'preco': 8.90, 'estoque': 45, 'categoria': 'Enlatados'},
      {'codigoBarras': '7891118025107', 'nome': 'Milho Verde Quero Lata 200g', 'descricao': 'Milho Verde em Conserva Quero', 'preco': 3.40, 'estoque': 70, 'categoria': 'Enlatados'}
    ];

    final batch = _firestore.batch();
    final agora = DateTime.now();

    for (final produtoData in produtos) {
      final produto = Produto(
        id: '',
        codigoPcms: '${produtos.indexOf(produtoData) + 1}',
        codigoBarras: produtoData['codigoBarras'] as String,
        nome: produtoData['nome'] as String,
        descricao: produtoData['descricao'] as String,
        preco: (produtoData['preco'] as num).toDouble(),
        estoque: produtoData['estoque'] as int,
        categoria: produtoData['categoria'] as String,
        criadoEm: agora,
        atualizadoEm: agora,
      );

      final docRef = _firestore.collection('produtos').doc();
      batch.set(docRef, produto.toMap());
    }

    await batch.commit();
  }

  Future<void> importarDadosTexto(String dadosTexto) async {
    final linhas = dadosTexto.split('\n');
    final batch = _firestore.batch();
    final agora = DateTime.now();
    
    for (final linha in linhas) {
      if (linha.trim().isEmpty) continue;
      
      final partes = linha.split('|');
      if (partes.length < 6) continue;
      
      final produto = Produto(
        id: '',
        codigoPcms: partes.length > 6 ? partes[6].trim() : '${linhas.indexOf(linha) + 1}',
        codigoBarras: partes[0].trim(),
        nome: partes[1].trim(),
        descricao: partes[2].trim(),
        preco: double.tryParse(partes[3].trim()) ?? 0.0,
        estoque: int.tryParse(partes[4].trim()) ?? 0,
        categoria: partes[5].trim(),
        criadoEm: agora,
        atualizadoEm: agora,
      );
      
      final docRef = _firestore.collection('produtos').doc();
      batch.set(docRef, produto.toMap());
    }
    
    await batch.commit();
  }

  Future<void> atualizarProduto(String codigoBarras, Map<String, dynamic> dados) async {
    final query = await _firestore
        .collection('produtos')
        .where('codigoBarras', isEqualTo: codigoBarras)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      dados['atualizadoEm'] = DateTime.now().millisecondsSinceEpoch;
      await doc.reference.update(dados);
    }
  }
}