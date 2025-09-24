import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:file_picker/file_picker.dart';
import '../services/produto_service.dart';
import 'produto_detalhes_screen.dart';
import 'adicionar_produto_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ProdutoService _produtoService = ProdutoService();
  MobileScannerController cameraController = MobileScannerController();
  final TextEditingController _webCodeController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    // Versão web - input manual
    if (kIsWeb) {
      return _buildWebVersion(context);
    }
    
    // Versão mobile - scanner real
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner de Código de Barras'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => cameraController.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
          IconButton(
            onPressed: () => cameraController.switchCamera(),
            icon: const Icon(Icons.camera_front),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Posicione o código de barras dentro da área de leitura',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebVersion(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Código de Barras'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Digite o código ou tire uma foto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dica: Use o botão foto para ver o código e digite no campo abaixo',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _webCodeController,
              decoration: const InputDecoration(
                labelText: 'Código de Barras',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _processWebCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Buscar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Foto',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? codigoBarras = barcodes.first.rawValue;
    if (codigoBarras == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Verifica se foi chamado da tela de adicionar produto
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments == 'adicionar') {
      Navigator.pop(context, codigoBarras);
      return;
    }

    try {
      final produto = await _produtoService.buscarPorCodigoBarras(codigoBarras);
      
      if (mounted) {
        if (produto != null) {
          _mostrarDialogoAcao(produto);
        } else {
          _mostrarDialogoProdutoNaoEncontrado(codigoBarras);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar produto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _mostrarDialogoAcao(produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code, size: 40, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      produto.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        produto.codigoBarras,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.attach_money, color: Colors.green.shade600, size: 24),
                                const SizedBox(height: 8),
                                Text(
                                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                const Text('Preço', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: produto.estoque > 0 ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: produto.estoque > 0 ? Colors.green.shade200 : Colors.red.shade200,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  produto.estoque > 0 ? Icons.inventory : Icons.warning,
                                  color: produto.estoque > 0 ? Colors.green.shade600 : Colors.red.shade600,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${produto.estoque}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: produto.estoque > 0 ? Colors.green.shade600 : Colors.red.shade600,
                                  ),
                                ),
                                const Text('Estoque', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (produto.categoria.isNotEmpty)
                      ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.category, color: Colors.blue.shade600, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                produto.categoria,
                                style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: produto.estoque > 0 ? () {
                              Navigator.pop(context);
                              _diminuirEstoque(produto);
                            } : null,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Retirar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdutoDetalhesScreen(produto: produto),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Ver Detalhes', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _diminuirEstoque(produto) async {
    if (produto.estoque <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto sem estoque!')),
      );
      return;
    }

    try {
      final produtoAtualizado = produto.copyWith(
        estoque: produto.estoque - 1,
        atualizadoEm: DateTime.now(),
      );
      
      await _produtoService.atualizarProduto(produto.id, produtoAtualizado);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estoque diminuído! Restam ${produtoAtualizado.estoque} unidades')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar estoque: $e')),
        );
      }
    }
  }

  void _mostrarDialogoProdutoNaoEncontrado(String codigoBarras) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Produto não encontrado'),
        content: Text('Produto com código $codigoBarras não foi encontrado. Deseja cadastrá-lo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdicionarProdutoScreen(codigoBarras: codigoBarras),
                ),
              );
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    // Simula leitura automática de código de barras
    final codigoSimulado = _simularLeituraCodigoBarras();
    
    setState(() {
      _webCodeController.text = codigoSimulado;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código detectado: $codigoSimulado'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Busca automaticamente
    _processWebCode();
  }

  String _simularLeituraCodigoBarras() {
    // Lista de códigos de barras comuns para simulação
    final codigos = [
      '7891000100103', // Coca-Cola
      '7891000315507', // Pepsi
      '7891000053508', // Guarana Antarctica
      '7891000244203', // Fanta Laranja
      '7891000100110', // Sprite
      '7891234567890', // Genérico 1
      '7891234567891', // Genérico 2
      '7891234567892', // Genérico 3
    ];
    
    // Retorna um código aleatório
    codigos.shuffle();
    return codigos.first;
  }

  void _processWebCode() async {
    final codigo = _webCodeController.text.trim();
    if (codigo.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    // Verifica se foi chamado da tela de adicionar produto
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments == 'adicionar') {
      Navigator.pop(context, codigo);
      return;
    }

    try {
      final produto = await _produtoService.buscarPorCodigoBarras(codigo);
      
      if (mounted) {
        if (produto != null) {
          _mostrarDialogoAcao(produto);
        } else {
          _mostrarDialogoProdutoNaoEncontrado(codigo);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar produto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      cameraController.dispose();
    }
    _webCodeController.dispose();
    super.dispose();
  }
}