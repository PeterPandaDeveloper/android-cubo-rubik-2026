import 'package:flutter/material.dart';
import 'algorithm.dart';

class Rubik {
  List<String> historial = [];

  // Representación del cubo por caras (9 stickers por cara)
  // 0-2: Arriba, 3-5: Medio, 6-8: Abajo
  late Map<String, List<Color>> caras;

  Rubik() {
    iniciarCubo();
  }

  void iniciarCubo() {
    historial.clear();
    caras = {
      'U': List.filled(9, Colors.white),
      'D': List.filled(9, Colors.yellow),
      'F': List.filled(9, Colors.green),
      'B': List.filled(9, Colors.blue),
      'L': List.filled(9, Colors.orange),
      'R': List.filled(9, Colors.red),
    };
  }

  Map<String, String> hacerMovimiento(String mov) {
    historial.add(mov);

    if (mov == 'U') _rotarU();
    if (mov == 'R') _rotarR();
    // Los demás movimientos siguen la misma lógica matricial...

    return {
      "accion": "Ejecutando: $mov",
      "alerta": Algorithm.analizarHistorial(historial),
    };
  }

  // LÓGICA DE ROTACIÓN MATRICIAL (Ejemplo U y R)
  void _rotarCaraReloj(String cara) {
    List<Color> c = List.from(caras[cara]!);
    caras[cara] = [c[6], c[3], c[0], c[7], c[4], c[1], c[8], c[5], c[2]];
  }

  void _rotarU() {
    _rotarCaraReloj('U');
    // Guardar fila superior adyacente
    List<Color> tempF = [caras['F']![0], caras['F']![1], caras['F']![2]];
    // L -> F
    caras['F']![0] = caras['L']![0];
    caras['F']![1] = caras['L']![1];
    caras['F']![2] = caras['L']![2];
    // B -> L
    caras['L']![0] = caras['B']![0];
    caras['L']![1] = caras['B']![1];
    caras['L']![2] = caras['B']![2];
    // R -> B
    caras['B']![0] = caras['R']![0];
    caras['B']![1] = caras['R']![1];
    caras['B']![2] = caras['R']![2];
    // Temp -> R
    caras['R']![0] = tempF[0];
    caras['R']![1] = tempF[1];
    caras['R']![2] = tempF[2];
  }

  void _rotarR() {
    _rotarCaraReloj('R');
    List<Color> tempU = [caras['U']![2], caras['U']![5], caras['U']![8]];
    // F -> U
    caras['U']![2] = caras['F']![2];
    caras['U']![5] = caras['F']![5];
    caras['U']![8] = caras['F']![8];
    // D -> F
    caras['F']![2] = caras['D']![2];
    caras['F']![5] = caras['D']![5];
    caras['F']![8] = caras['D']![8];
    // B -> D (Ojo, atrás está invertido)
    caras['D']![2] = caras['B']![6];
    caras['D']![5] = caras['B']![3];
    caras['D']![8] = caras['B']![0];
    // Temp -> B
    caras['B']![6] = tempU[0];
    caras['B']![3] = tempU[1];
    caras['B']![0] = tempU[2];
  }
}
