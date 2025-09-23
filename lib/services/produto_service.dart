import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';

class ProdutoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'produtos';

  Future<void> adicionarProduto(Produto produto) async {
    await _firestore.collection(_collection).add(produto.toMap());
  }

  Future<Produto?> buscarPorCodigoBarras(String codigoBarras) async {
    final query = await _firestore
        .collection(_collection)
        .where('codigoBarras', isEqualTo: codigoBarras)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return Produto.fromMap(doc.data(), doc.id);
    }
    return null;
  }

  Future<List<Produto>> listarProdutos() async {
    final query = await _firestore
        .collection(_collection)
        .orderBy('nome')
        .get();

    return query.docs
        .map((doc) => Produto.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> atualizarProduto(String id, Produto produto) async {
    await _firestore
        .collection(_collection)
        .doc(id)
        .update(produto.toMap());
  }

  Future<void> deletarProduto(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Stream<List<Produto>> streamProdutos() {
    return _firestore
        .collection(_collection)
        .orderBy('nome')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Produto.fromMap(doc.data(), doc.id))
            .toList());
  }
}