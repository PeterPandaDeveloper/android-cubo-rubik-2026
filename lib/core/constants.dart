// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';

class Constants {
  // Colores del cubo y de la terminal
  static const Color terminalText = Colors.greenAccent;
  static const Color background = Colors.black;

  // Tu sistema de Lore
  static const List<String> loreMessages = [
    "Iniciando protocolo de análisis...",
    "Conectando con base de datos de algoritmos...",
    "Sincronización CFOP establecida.",
    "Advertencia: Anomalía detectada en rotación R.",
    "Calculando permutación de aristas...",
  ];

  static String obtenerMensajeAleatorio() {
    return loreMessages[DateTime.now().millisecond % loreMessages.length];
  }
}
