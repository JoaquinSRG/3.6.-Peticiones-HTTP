import 'dart:convert'; // Para convertir JSON
import 'package:http/http.dart' as http; // Para hacer peticiones
import '../models/pokemon_simple.dart';

class PokemonApi {
  /// Este método hace UNA petición y devuelve UNA lista
  static Future<List<PokemonSimple>> obtenerPokemon() async {
    // 1. La dirección de la API (URL)
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10');
    // 2. Hacer la petición
    final respuesta = await http.get(url);
    // 3. Verificar que funcionó (200 = OK)
    if (respuesta.statusCode == 200) {
      // 4. Convertir el texto JSON a un mapa de Dart
      final datos = json.decode(respuesta.body);
      // 5. Sacar la lista de resultados
      final List resultados = datos['results'];
      // 6. Convertir cada JSON a un objeto PokemonSimple
      return resultados.map((json) => PokemonSimple.fromJson(json)).toList();
    } else {
      // Si falló, lanzar un error
      throw Exception('Error al cargar Pokémon');
    }
  }
}
