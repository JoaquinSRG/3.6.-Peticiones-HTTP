/// Esta clase representa UN Pokémon de forma simple
class PokemonSimple {
  final String nombre; // El nombre del Pokémon

  PokemonSimple({required this.nombre});

  // Método especial: convierte JSON a objeto Dart
  factory PokemonSimple.fromJson(Map<String, dynamic> json) {
    return PokemonSimple(
      nombre: json['name'], // Sacamos el "name" del JSON
    );
  }
}
