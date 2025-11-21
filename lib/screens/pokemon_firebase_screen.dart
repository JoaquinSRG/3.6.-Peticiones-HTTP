import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/firebase_service.dart';

class PokemonFirebaseScreen extends StatefulWidget {
  const PokemonFirebaseScreen({super.key});

  @override
  State<PokemonFirebaseScreen> createState() => _PokemonFirebaseScreenState();
}

class _PokemonFirebaseScreenState extends State<PokemonFirebaseScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  // Agregar nuevo Pokemon
  Future<void> _addPokemon() async {
    if (_nameController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _levelController.text.isEmpty) {
      _showMessage('Por favor completa todos los campos');
      return;
    }

    try {
      final pokemon = Pokemon(
        name: _nameController.text.trim(),
        type: _typeController.text.trim(),
        level: int.parse(_levelController.text.trim()),
      );

      await _firebaseService.addPokemon(pokemon);

      _nameController.clear();
      _typeController.clear();
      _levelController.clear();

      if (mounted) {
        Navigator.pop(context);
        _showMessage('¡Pokemon agregado exitosamente!');
      }
    } catch (e) {
      _showMessage('Error al agregar Pokemon: $e');
    }
  }

  // Actualizar Pokemon existente
  Future<void> _updatePokemon(Pokemon pokemon) async {
    _nameController.text = pokemon.name;
    _typeController.text = pokemon.type;
    _levelController.text = pokemon.level.toString();

    await _showPokemonDialog(
      title: 'Actualizar Pokemon',
      confirmText: 'Actualizar',
      onConfirm: () async {
        try {
          final updatedPokemon = Pokemon(
            id: pokemon.id,
            name: _nameController.text.trim(),
            type: _typeController.text.trim(),
            level: int.parse(_levelController.text.trim()),
            createdAt: pokemon.createdAt,
          );

          await _firebaseService.updatePokemon(pokemon.id!, updatedPokemon);

          _nameController.clear();
          _typeController.clear();
          _levelController.clear();

          if (mounted) {
            Navigator.pop(context);
            _showMessage('¡Pokemon actualizado exitosamente!');
          }
        } catch (e) {
          _showMessage('Error al actualizar Pokemon: $e');
        }
      },
    );
  }

  // Eliminar Pokemon
  Future<void> _deletePokemon(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar a $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firebaseService.deletePokemon(id);
        _showMessage('Pokemon eliminado');
      } catch (e) {
        _showMessage('Error al eliminar Pokemon: $e');
      }
    }
  }

  // Mostrar diálogo para agregar/editar Pokemon
  Future<void> _showPokemonDialog({
    String title = 'Agregar Pokemon',
    String confirmText = 'Agregar',
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Nivel',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              _typeController.clear();
              _levelController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(onPressed: onConfirm, child: Text(confirmText)),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon - Firebase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Pokemon>>(
        stream: _firebaseService.getPokemonStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando Pokemon...'),
                ],
              ),
            );
          }

          final pokemonList = snapshot.data ?? [];

          if (pokemonList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    size: 96,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay Pokemon registrados',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para agregar uno',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTypeColor(pokemon.type),
                    child: Text(
                      pokemon.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    pokemon.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tipo: ${pokemon.type} • Nivel: ${pokemon.level}',
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _updatePokemon(pokemon);
                      } else if (value == 'delete') {
                        _deletePokemon(pokemon.id!, pokemon.name);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _nameController.clear();
          _typeController.clear();
          _levelController.clear();
          _showPokemonDialog(
            title: 'Agregar Pokemon',
            confirmText: 'Agregar',
            onConfirm: _addPokemon,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
      case 'fuego':
        return Colors.orange;
      case 'water':
      case 'agua':
        return Colors.blue;
      case 'grass':
      case 'planta':
        return Colors.green;
      case 'electric':
      case 'eléctrico':
        return Colors.yellow[700]!;
      case 'psychic':
      case 'psíquico':
        return Colors.pink;
      case 'dark':
      case 'oscuro':
        return Colors.grey[800]!;
      default:
        return Colors.teal;
    }
  }
}
