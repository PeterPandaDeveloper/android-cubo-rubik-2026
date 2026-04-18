import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'core/rubik.dart';

void main() => runApp(const CuboLoreApp());

class CuboLoreApp extends StatelessWidget {
  const CuboLoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final Rubik miCubo = Rubik();
  String consolaCubo = "Cubo Lore OS v1.0.0\nIniciando motor gráfico...";
  final ScrollController _scrollController = ScrollController();

  void presionarBoton(String movimiento) {
    setState(() {
      Map<String, String> resultado = miCubo.hacerMovimiento(movimiento);
      consolaCubo += "\n> ${resultado["accion"]}";
      if (resultado["alerta"]!.isNotEmpty)
        consolaCubo += "\n  ${resultado["alerta"]}";

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terminal Rubik - Análisis Activo',
          style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          // 1. LA TERMINAL (30% de la pantalla)
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.greenAccent.withOpacity(0.5)),
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Text(
                consolaCubo,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // 2. EL CUBO RENDERIZADO VISUALMENTE (Desplegado en cruz)
          Expanded(
            child: Center(
              child: Transform.scale(
                scale: 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dibujarCara(miCubo.caras['U']!), // Arriba
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _dibujarCara(miCubo.caras['L']!), // Izquierda
                        _dibujarCara(miCubo.caras['F']!), // Frente
                        _dibujarCara(miCubo.caras['R']!), // Derecha
                        _dibujarCara(miCubo.caras['B']!), // Atrás
                      ],
                    ),
                    _dibujarCara(miCubo.caras['D']!), // Abajo
                  ],
                ),
              ),
            ),
          ),

          // 3. LOS CONTROLES DE MANDO
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _crearBoton('U'),
                _crearBoton('R'),
                _crearBoton('F'),
                _crearBoton('Reset'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función mágica que dibuja una cara 3x3
  Widget _dibujarCara(List<Color> colores) {
    return Container(
      width: 66,
      height: 66,
      margin: const EdgeInsets.all(2),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: colores[index],
              border: Border.all(color: Colors.black, width: 1),
            ),
          );
        },
      ),
    );
  }

  Widget _crearBoton(String letra) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        side: const BorderSide(color: Colors.greenAccent),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      onPressed: () {
        if (letra == 'Reset') {
          setState(() {
            miCubo.iniciarCubo();
            consolaCubo += "\n> REINICIO DEL SISTEMA.";
          });
        } else {
          presionarBoton(letra);
        }
      },
      child: Text(
        letra,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
