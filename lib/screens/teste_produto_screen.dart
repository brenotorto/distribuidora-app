import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class TesteProdutoScreen extends StatelessWidget {
  const TesteProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste - Adicionar Produto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _adicionarProdutoTeste(context),
          child: const Text('Adicionar Produto de Teste'),
        ),
      ),
    );
  }

  Future<void> _adicionarProdutoTeste(BuildContext context) async {
    try {
      final agora = DateTime.now();
      final produto = Produto(
        id: '',
        codigoPcms: '12345',
        codigoBarras: '7891000100103',
        nome: 'Coca-Cola 350ml',
        descricao: 'Refrigerante Coca-Cola lata 350ml',
        preco: 4.50,
        estoque: 10,
        categoria: 'Bebidas',
        criadoEm: agora,
        atualizadoEm: agora,
      );

      await ProdutoService().adicionarProduto(produto);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto de teste adicionado! Código: 7891000100103')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }
}