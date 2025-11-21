import 'package:flutter/material.dart';
import 'screens/pokeemon_prueba_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LDSW: Widgets básicos',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      // Home ahora es una pantalla con fondo, icono y "Hello World"
      home: const HomeScreen(),
      routes: {'/demo': (_) => const WidgetsDemoPage()},
    );
  }
}

/// Pantalla de inicio que cumple con los criterios:
/// - Texto "Hello World"
/// - Imagen de fondo (AssetImage)
/// - Icon agregado
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
                // Oscurecer un poco el fondo para legibilidad
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
              ),
            ),
          ),
          // Contenido centrado
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.movie, // Ícono visible
                    size: 96,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mi Aplicación',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hello World',
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botón para ir a la prueba de HTTP
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PokemonPruebaScreen(),
            ),
          );
        },
        icon: const Icon(Icons.catching_pokemon),
        label: const Text('Probar HTTP'),
      ),
    );
  }
}

class WidgetsDemoPage extends StatelessWidget {
  const WidgetsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LDSW: Widgets básicos')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TEXT: ejemplo centrado con estilo
              const Text(
                'Text: ejemplo centrado con estilo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // ROW: tres contenedores cuadrados separados
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sq('A', Colors.teal),
                  _sq('B', Colors.orange),
                  _sq('C', Colors.indigo),
                ],
              ),
              const SizedBox(height: 16),

              // CONTAINER: tarjeta con borde, margin y padding
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Container con margin, padding y borde.'),
              ),
              const SizedBox(height: 16),

              // COLUMN: lista vertical simple
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2FFFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Column: elementos verticales',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text('• Elemento 1'),
                    Text('• Elemento 2'),
                    Text('• Elemento 3'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // STACK: superposición con Positioned
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Stack',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Superposición con Positioned',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Cierre
              const Text(
                'Se usaron Text, Row, Column, Stack y Container.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para los cuadrados del Row
  static Widget _sq(String label, Color color) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
