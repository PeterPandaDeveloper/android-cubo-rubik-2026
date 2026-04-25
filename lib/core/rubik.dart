import 'package:flutter/material.dart';
import 'algorithm.dart';

class Rubik {
  List<String> historial = [];

  // Representación del cubo por caras (9 stickers por cara)
  // Índices: 0-2 (Top), 3-5 (Middle), 6-8 (Bottom)
  late Map<String, List<Color>> caras;

  Rubik() {
    iniciarCubo();
  }

  void iniciarCubo() {
    historial.clear();
    // Colores estándar oficiales
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

    // Enrutador de Movimientos (Normales y Primas)
    if (mov == 'U')
      _rotarU();
    else if (mov == "U'")
      _rotarUPrima();
    else if (mov == 'D')
      _rotarD();
    else if (mov == "D'")
      _rotarDPrima();
    else if (mov == 'R')
      _rotarR();
    else if (mov == "R'")
      _rotarRPrima();
    else if (mov == 'L')
      _rotarL();
    else if (mov == "L'")
      _rotarLPrima();
    else if (mov == 'F')
      _rotarF();
    else if (mov == "F'")
      _rotarFPrima();
    else if (mov == 'B')
      _rotarB();
    else if (mov == "B'")
      _rotarBPrima();

    return {
      "accion": "Ejecutando rotación: $mov",
      // AQUÍ ESTÁ EL CAMBIO: Le enviamos las caras al analizador
      "alerta": Algorithm.analizarHistorial(historial, caras),
    };
  }

  // ----------------------------------------------------------------
  // ROTACIONES BASE DE LAS CARAS (9 stickers)
  // ----------------------------------------------------------------
  void _rotarCaraReloj(String cara) {
    List<Color> c = List.from(caras[cara]!);
    caras[cara] = [c[6], c[3], c[0], c[7], c[4], c[1], c[8], c[5], c[2]];
  }

  void _rotarCaraAntiReloj(String cara) {
    List<Color> c = List.from(caras[cara]!);
    caras[cara] = [c[2], c[5], c[8], c[1], c[4], c[7], c[0], c[3], c[6]];
  }

  // ----------------------------------------------------------------
  // LÓGICA DE MOVIMIENTOS NORMALES (Sentido Horario)
  // ----------------------------------------------------------------

  void _rotarU() {
    _rotarCaraReloj('U');
    List<Color> temp = [caras['F']![0], caras['F']![1], caras['F']![2]];
    caras['F']![0] = caras['R']![0];
    caras['F']![1] = caras['R']![1];
    caras['F']![2] = caras['R']![2];
    caras['R']![0] = caras['B']![0];
    caras['R']![1] = caras['B']![1];
    caras['R']![2] = caras['B']![2];
    caras['B']![0] = caras['L']![0];
    caras['B']![1] = caras['L']![1];
    caras['B']![2] = caras['L']![2];
    caras['L']![0] = temp[0];
    caras['L']![1] = temp[1];
    caras['L']![2] = temp[2];
  }

  void _rotarD() {
    _rotarCaraReloj('D');
    List<Color> temp = [caras['F']![6], caras['F']![7], caras['F']![8]];
    caras['F']![6] = caras['L']![6];
    caras['F']![7] = caras['L']![7];
    caras['F']![8] = caras['L']![8];
    caras['L']![6] = caras['B']![6];
    caras['L']![7] = caras['B']![7];
    caras['L']![8] = caras['B']![8];
    caras['B']![6] = caras['R']![6];
    caras['B']![7] = caras['R']![7];
    caras['B']![8] = caras['R']![8];
    caras['R']![6] = temp[0];
    caras['R']![7] = temp[1];
    caras['R']![8] = temp[2];
  }

  void _rotarR() {
    _rotarCaraReloj('R');
    List<Color> temp = [caras['U']![2], caras['U']![5], caras['U']![8]];
    caras['U']![2] = caras['F']![2];
    caras['U']![5] = caras['F']![5];
    caras['U']![8] = caras['F']![8];
    caras['F']![2] = caras['D']![2];
    caras['F']![5] = caras['D']![5];
    caras['F']![8] = caras['D']![8];
    caras['D']![2] = caras['B']![6];
    caras['D']![5] = caras['B']![3];
    caras['D']![8] = caras['B']![0];
    caras['B']![0] = temp[2];
    caras['B']![3] = temp[1];
    caras['B']![6] = temp[0];
  }

  void _rotarL() {
    _rotarCaraReloj('L');
    List<Color> temp = [caras['U']![0], caras['U']![3], caras['U']![6]];
    caras['U']![0] = caras['B']![8];
    caras['U']![3] = caras['B']![5];
    caras['U']![6] = caras['B']![2];
    caras['B']![2] = caras['D']![6];
    caras['B']![5] = caras['D']![3];
    caras['B']![8] = caras['D']![0];
    caras['D']![0] = caras['F']![0];
    caras['D']![3] = caras['F']![3];
    caras['D']![6] = caras['F']![6];
    caras['F']![0] = temp[0];
    caras['F']![3] = temp[1];
    caras['F']![6] = temp[2];
  }

  void _rotarF() {
    _rotarCaraReloj('F');
    List<Color> temp = [caras['U']![6], caras['U']![7], caras['U']![8]];
    caras['U']![6] = caras['L']![8];
    caras['U']![7] = caras['L']![5];
    caras['U']![8] = caras['L']![2];
    caras['L']![2] = caras['D']![0];
    caras['L']![5] = caras['D']![1];
    caras['L']![8] = caras['D']![2];
    caras['D']![0] = caras['R']![6];
    caras['D']![1] = caras['R']![3];
    caras['D']![2] = caras['R']![0];
    caras['R']![0] = temp[0];
    caras['R']![3] = temp[1];
    caras['R']![6] = temp[2];
  }

  void _rotarB() {
    _rotarCaraReloj('B');
    List<Color> temp = [caras['U']![0], caras['U']![1], caras['U']![2]];
    caras['U']![0] = caras['R']![2];
    caras['U']![1] = caras['R']![5];
    caras['U']![2] = caras['R']![8];
    caras['R']![2] = caras['D']![8];
    caras['R']![5] = caras['D']![7];
    caras['R']![8] = caras['D']![6];
    caras['D']![6] = caras['L']![6];
    caras['D']![7] = caras['L']![3];
    caras['D']![8] = caras['L']![0];
    caras['L']![0] = temp[2];
    caras['L']![3] = temp[1];
    caras['L']![6] = temp[0];
  }

  // ----------------------------------------------------------------
  // LÓGICA DE MOVIMIENTOS INVERSOS (Primas / Sentido Antihorario)
  // ----------------------------------------------------------------

  void _rotarUPrima() {
    _rotarCaraAntiReloj('U');
    List<Color> temp = [caras['F']![0], caras['F']![1], caras['F']![2]];
    caras['F']![0] = caras['L']![0];
    caras['F']![1] = caras['L']![1];
    caras['F']![2] = caras['L']![2];
    caras['L']![0] = caras['B']![0];
    caras['L']![1] = caras['B']![1];
    caras['L']![2] = caras['B']![2];
    caras['B']![0] = caras['R']![0];
    caras['B']![1] = caras['R']![1];
    caras['B']![2] = caras['R']![2];
    caras['R']![0] = temp[0];
    caras['R']![1] = temp[1];
    caras['R']![2] = temp[2];
  }

  void _rotarDPrima() {
    _rotarCaraAntiReloj('D');
    List<Color> temp = [caras['F']![6], caras['F']![7], caras['F']![8]];
    caras['F']![6] = caras['R']![6];
    caras['F']![7] = caras['R']![7];
    caras['F']![8] = caras['R']![8];
    caras['R']![6] = caras['B']![6];
    caras['R']![7] = caras['B']![7];
    caras['R']![8] = caras['B']![8];
    caras['B']![6] = caras['L']![6];
    caras['B']![7] = caras['L']![7];
    caras['B']![8] = caras['L']![8];
    caras['L']![6] = temp[0];
    caras['L']![7] = temp[1];
    caras['L']![8] = temp[2];
  }

  void _rotarRPrima() {
    _rotarCaraAntiReloj('R');
    List<Color> temp = [caras['U']![2], caras['U']![5], caras['U']![8]];
    caras['U']![2] = caras['B']![6];
    caras['U']![5] = caras['B']![3];
    caras['U']![8] = caras['B']![0];
    caras['B']![0] = caras['D']![8];
    caras['B']![3] = caras['D']![5];
    caras['B']![6] = caras['D']![2];
    caras['D']![2] = caras['F']![2];
    caras['D']![5] = caras['F']![5];
    caras['D']![8] = caras['F']![8];
    caras['F']![2] = temp[0];
    caras['F']![5] = temp[1];
    caras['F']![8] = temp[2];
  }

  void _rotarLPrima() {
    _rotarCaraAntiReloj('L');
    List<Color> temp = [caras['U']![0], caras['U']![3], caras['U']![6]];
    caras['U']![0] = caras['F']![0];
    caras['U']![3] = caras['F']![3];
    caras['U']![6] = caras['F']![6];
    caras['F']![0] = caras['D']![0];
    caras['F']![3] = caras['D']![3];
    caras['F']![6] = caras['D']![6];
    caras['D']![0] = caras['B']![8];
    caras['D']![3] = caras['B']![5];
    caras['D']![6] = caras['B']![2];
    caras['B']![2] = temp[6];
    caras['B']![5] = temp[3];
    caras['B']![8] = temp[0];
  }

  void _rotarFPrima() {
    _rotarCaraAntiReloj('F');
    List<Color> temp = [caras['U']![6], caras['U']![7], caras['U']![8]];
    caras['U']![6] = caras['R']![0];
    caras['U']![7] = caras['R']![3];
    caras['U']![8] = caras['R']![6];
    caras['R']![0] = caras['D']![2];
    caras['R']![3] = caras['D']![1];
    caras['R']![6] = caras['D']![0];
    caras['D']![0] = caras['L']![2];
    caras['D']![1] = caras['L']![5];
    caras['D']![2] = caras['L']![8];
    caras['L']![2] = temp[2];
    caras['L']![5] = temp[1];
    caras['L']![8] = temp[0];
  }

  void _rotarBPrima() {
    _rotarCaraAntiReloj('B');
    List<Color> temp = [caras['U']![0], caras['U']![1], caras['U']![2]];
    caras['U']![0] = caras['L']![6];
    caras['U']![1] = caras['L']![3];
    caras['U']![2] = caras['L']![0];
    caras['L']![0] = caras['D']![8];
    caras['L']![3] = caras['D']![7];
    caras['L']![6] = caras['D']![6];
    caras['D']![6] = caras['R']![8];
    caras['D']![7] = caras['R']![5];
    caras['D']![8] = caras['R']![2];
    caras['R']![2] = temp[0];
    caras['R']![5] = temp[1];
    caras['R']![8] = temp[2];
  }
}
