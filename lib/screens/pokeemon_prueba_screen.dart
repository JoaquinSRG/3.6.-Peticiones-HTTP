import 'package:flutter/material.dart';
import '../services/pokemon_api.dart';
import '../models/pokemon_simple.dart';

class PokemonPruebaScreen extends StatefulWidget {
  const PokemonPruebaScreen({super.key});

  @override
  State<PokemonPruebaScreen> createState() => _PokemonPruebaScreenState();
}

class _PokemonPruebaScreenState extends State<PokemonPruebaScreen> {
  // ESTADO: aquí guardamos la lista de Pokémon
  List<PokemonSimple> listaPokemon = [];

  bool estaCargando = false;

  String? mensajeError;

  /// Este método hace la petición HTTP
  Future<void> cargarPokemon() async {
    setState(() {
      estaCargando = true;
      mensajeError = null;
    });

    try {
      final pokemon = await PokemonApi.obtenerPokemon();

      setState(() {
        listaPokemon = pokemon;
        estaCargando = false;
      });
    } catch (e) {
      // Si algo salió mal, mostrar el error
      setState(() {
        mensajeError = 'Error: $e';
        estaCargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Primera Petición HTTP'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // BOTÓN para cargar Pokémon
            ElevatedButton.icon(
              onPressed: estaCargando ? null : cargarPokemon,
              icon: const Icon(Icons.download),
              label: const Text('Cargar Pokémon desde Internet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 20),

            // INDICADOR de carga
            if (estaCargando) const CircularProgressIndicator(),

            // MENSAJE de error
            if (mensajeError != null)
              Text(mensajeError!, style: const TextStyle(color: Colors.red)),

            // LISTA de Pokémon
            Expanded(
              child: ListView.builder(
                itemCount: listaPokemon.length,
                itemBuilder: (context, index) {
                  final pokemon = listaPokemon[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        pokemon.nombre.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
