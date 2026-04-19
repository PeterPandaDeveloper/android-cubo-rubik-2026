import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants.dart';
import 'core/rubik.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const CuboLoreApp());
  });
}

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
  String consolaCubo =
      "Cubo Lore OS v1.0.0\n[Orientación Horizontal Bloqueada]\nIniciando motores...";
  final ScrollController _scrollController = ScrollController();

  List<String> registroDescubrimientos = [];

  void presionarBoton(String movimiento) {
    setState(() {
      Map<String, String> resultado = miCubo.hacerMovimiento(movimiento);
      consolaCubo += "\n> ${resultado["accion"]}";

      if (resultado["alerta"]!.isNotEmpty) {
        consolaCubo += "\n  ${resultado["alerta"]}";
        if (!registroDescubrimientos.contains(resultado["alerta"]!)) {
          registroDescubrimientos.add(resultado["alerta"]!);
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void abrirRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PantallaRegistro(loreDesbloqueado: registroDescubrimientos),
      ),
    );
  }

  // NUEVA FUNCIÓN: Ventana emergente de confirmación
  void _mostrarDialogoReinicio() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "⚠️ ADVERTENCIA",
            style: TextStyle(
              color: Colors.redAccent,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "¿Estás seguro de que deseas reiniciar la matriz del cubo?\nSe restablecerán todos los colores de las caras.",
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(), // Cierra la ventana sin hacer nada
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                side: const BorderSide(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra la ventana
                setState(() {
                  miCubo.iniciarCubo();
                  consolaCubo += "\n\n> [SISTEMA Y MATRIZ RESTAURADOS]\n";
                });
              },
              child: const Text(
                "Confirmar Reinicio",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Rubix Cube Simulator',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'monospace',
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        toolbarHeight: 45,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.menu_book, color: Colors.amberAccent),
            label: const Text(
              "Progreso",
              style: TextStyle(color: Colors.amberAccent, fontSize: 16),
            ),
            onPressed: abrirRegistro,
          ),

          const SizedBox(width: 25),

          // BOTÓN DE REINICIO ACTUALIZADO PARA LLAMAR A LA VENTANA
          TextButton.icon(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            label: const Text(
              "Reinicio",
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
            onPressed: _mostrarDialogoReinicio, // Llama a la ventana emergente
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.greenAccent.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _dibujarCara(miCubo.caras['U']!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dibujarCara(miCubo.caras['L']!),
                              _dibujarCara(miCubo.caras['F']!),
                              _dibujarCara(miCubo.caras['R']!),
                              _dibujarCara(miCubo.caras['B']!),
                            ],
                          ),
                          _dibujarCara(miCubo.caras['D']!),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Text(
                        consolaCubo,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _crearBoton('U'),
                        _crearBoton('D'),
                        _crearBoton('R'),
                        _crearBoton('L'),
                        _crearBoton('F'),
                        _crearBoton('B'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _crearBoton("U'"),
                        _crearBoton("D'"),
                        _crearBoton("R'"),
                        _crearBoton("L'"),
                        _crearBoton("F'"),
                        _crearBoton("B'"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dibujarCara(List<Color> colores) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.all(1),
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
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
          );
        },
      ),
    );
  }

  Widget _crearBoton(String letra) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: Colors.greenAccent, width: 1.5),
          ),
          onPressed: () => presionarBoton(letra),
          child: Text(
            letra,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// PANTALLA: REGISTRO DE PROGRESO Y LORE
// -------------------------------------------------------------------
class PantallaRegistro extends StatelessWidget {
  final List<String> loreDesbloqueado;

  const PantallaRegistro({super.key, required this.loreDesbloqueado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Progreso y Anomalías',
          style: TextStyle(color: Colors.amberAccent, fontFamily: 'monospace'),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.amberAccent),
      ),
      body: loreDesbloqueado.isEmpty
          ? const Center(
              child: Text(
                "NO HAY PROGRESO REGISTRADO.\nEjecuta secuencias CFOP para descubrir anomalías.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'monospace',
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: loreDesbloqueado.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.amberAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "ENTRADA #${index + 1}:\n${loreDesbloqueado[index]}",
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
