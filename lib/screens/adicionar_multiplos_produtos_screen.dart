import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class AdicionarMultiplosProdutosScreen extends StatefulWidget {
  const AdicionarMultiplosProdutosScreen({super.key});

  @override
  State<AdicionarMultiplosProdutosScreen> createState() => _AdicionarMultiplosProdutosScreenState();
}

class _AdicionarMultiplosProdutosScreenState extends State<AdicionarMultiplosProdutosScreen> {
  final TextEditingController _textController = TextEditingController();
  final ProdutoService _produtoService = ProdutoService();
  bool _isLoading = false;
  List<Produto> _produtosParsed = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Múltiplos Produtos'),
        backgroundColor: const Color(0xFF00D4AA),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cole os dados dos produtos (um por linha):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Formato: codigo nome_fabricante descricao preco',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Ex:\n12975 7891991009584 Ambev Cerveja Antarctica Original - GRF 300 ml 3,88\n7771 78905351 Ambev Cerveja Antarctica Original - GRF 600ml 8,57',
                  border: OutlineInputBorder(),
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _parseProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Analisar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _salvarProdutos,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4AA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Salvar (${_produtosParsed.length})'),
                  ),
                ),
              ],
            ),
            if (_produtosParsed.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Produtos analisados:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _produtosParsed.length,
                  itemBuilder: (context, index) {
                    final produto = _produtosParsed[index];
                    return Card(
                      child: ListTile(
                        title: Text(produto.nome),
                        subtitle: Text('PCMS: ${produto.codigoPcms} | ${produto.codigoBarras} - R\$ ${produto.preco.toStringAsFixed(2)}'),
                        trailing: Text(produto.categoria),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _parseProducts() {
    final lines = _textController.text.trim().split('\n');
    final produtos = <Produto>[];
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      try {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          final codigo = parts[0];
          final codigoBarras = parts[1];
          final preco = double.parse(parts.last.replaceAll(',', '.'));
          
          final descricaoCompleta = parts.sublist(2, parts.length - 1).join(' ');
          final fabricante = parts[2];
          
          final produto = Produto(
            id: '',
            codigoPcms: codigo,
            codigoBarras: codigoBarras,
            nome: descricaoCompleta,
            descricao: descricaoCompleta,
            preco: preco,
            categoria: fabricante,
            estoque: 0,
            criadoEm: DateTime.now(),
            atualizadoEm: DateTime.now(),
          );
          produtos.add(produto);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na linha: $line')),
        );
      }
    }
    
    setState(() {
      _produtosParsed = produtos;
    });
  }

  Future<void> _salvarProdutos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (final produto in _produtosParsed) {
        await _produtoService.adicionarProduto(produto);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_produtosParsed.length} produtos adicionados com sucesso!')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produtos: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}