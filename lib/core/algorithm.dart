class Algorithm {
  // Diccionario de algoritmos (equivalente a tus validaciones en C++)
  static const Map<String, String> cfopDictionary = {
    "RUR'U'": "Sexy Move (Base)",
    "R'FRF'": "Sledgehammer",
    "URU'R'": "Inserción F2L",
    "F R U R' U' F'": "OLL Básico (Cruz)",
    "R U R' U R U2 R'": "OLL Sune",
  };

  // Función que escanea el historial buscando patrones
  static String analizarHistorial(List<String> historial) {
    if (historial.length < 4) return "";

    // Unimos los movimientos para buscar coincidencias
    String secuenciaCompleta = historial.join("");

    String mensajeAlerta = "";

    // Escáner de algoritmos registrados
    cfopDictionary.forEach((secuencia, nombre) {
      // Quitamos espacios del diccionario para comparar fácil
      String seqLimpia = secuencia.replaceAll(" ", "");
      if (secuenciaCompleta.endsWith(seqLimpia)) {
        mensajeAlerta =
            "\n[!] ALGORITMO DETECTADO: $nombre\n>>> Sincronización de memoria al 85%...";
      }
    });

    // Tu sistema de Lore Oculto (Anomalías)
    if (secuenciaCompleta.contains("RUR'U'RUR'U'RUR'U'")) {
      mensajeAlerta =
          "\n[CRÍTICO] Bucle temporal detectado (Sexy Move x3).\n>>> La realidad del cubo se está desestabilizando.";
    }

    return mensajeAlerta;
  }
}
