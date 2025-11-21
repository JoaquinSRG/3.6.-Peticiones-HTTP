import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'pokemon';

  CollectionReference get _pokemonCollection =>
      _firestore.collection(_collectionName);

  Future<String> addPokemon(Pokemon pokemon) async {
    try {
      DocumentReference docRef = await _pokemonCollection.add(
        pokemon.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar Pokemon: $e');
    }
  }

  Stream<List<Pokemon>> getPokemonStream() {
    return _pokemonCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Pokemon.fromFirestore(doc))
              .toList();
        });
  }

  Future<Pokemon?> getPokemonById(String id) async {
    try {
      DocumentSnapshot doc = await _pokemonCollection.doc(id).get();
      if (doc.exists) {
        return Pokemon.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener Pokemon');
    }
  }

  Future<void> updatePokemon(String id, Pokemon pokemon) async {
    try {
      await _pokemonCollection.doc(id).update(pokemon.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar Pokemon: $e');
    }
  }

  Future<void> deletePokemon(String id) async {
    try {
      await _pokemonCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar Pokemon: $e');
    }
  }
}
