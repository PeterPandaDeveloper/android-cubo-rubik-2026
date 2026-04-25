import 'dart:math';
import 'package:flutter/material.dart';
import 'constants.dart';

class Algorithm {
  // Diccionario de Algoritmos para los Finales
  static final Map<String, List<String>> secuenciasSecretas = {
    "Sune (OLL 27)": ["R", "U", "R'", "U", "R", "U", "U", "R'"],
    "Anti-Sune (OLL 26)": ["R", "U", "U", "R'", "U'", "R", "U'", "R'"],
    "T-Perm (PLL)": [
      "R",
      "U",
      "R'",
      "U'",
      "R'",
      "F",
      "R",
      "R",
      "U'",
      "R'",
      "U'",
      "R",
      "U",
      "R'",
      "F'",
    ],
    "J-Perm (PLL)": [
      "R",
      "U",
      "R'",
      "F'",
      "R",
      "U",
      "R'",
      "U'",
      "R'",
      "F",
      "R",
      "R",
      "U'",
      "R'",
    ],
    "Y-Perm (PLL)": [
      "F",
      "R",
      "U'",
      "R'",
      "U'",
      "R",
      "U",
      "R'",
      "F'",
      "R",
      "U",
      "R'",
      "U'",
      "R'",
      "F",
      "R",
      "F'",
    ],
  };

  // --- LOS 4 FINALES ---
  static const String final1Wynara =
      "FINAL 1 - WYNARA PIEDRAGUDA:\n\"Mi miedo crece cada día. Siento que mi señor marido me está siendo infiel. Últimamente es muy evasivo; lo he visto escabullirse de la casa y, a veces, a primera hora de la mañana ya no está. Cuando le pregunto a dónde fue, me dice que estuvo en la forja 'El Coloso en Llamas'. Sin embargo, hablé con Urkar Than, el maese forjador, y me aseguró que no lo ha visto por allí.\nNo tengo pruebas, no puedo confrontarlo. Supongo que debería estar agradecida de que un noble me haya escogido como su mujer, siendo yo quien soy. Pero, como cabeza de la casa TiroSeguro, él debería avergonzarse. Es cierto que aún no he podido darle descendencia, y me entristece en el alma pensar que busca en otro lecho lo que yo no le he dado. Ruego a los dioses que todo esto sea solo mi imaginación.\"";

  static const String final2Sherlock =
      "FINAL 2 - SHERLOCK MURIK II:\n\"North. Un reino salido de la nada. El crisol de mi patria tiembla a mi andar; mis elefantes acorazados están listos, mis hombres aguardan, mis huestes claman sangre. Pero no puedo atacar aún. Ese reino ha crecido tanto que, por primera vez, saboreo el amargo temor a la derrota.\nComo un zorro, deberé esperar en las sombras. El rey cometerá un error y, cuando lo haga, me lanzaré directo a su yugular. No lo soltaré. Sueño con mis bestias derribando los muros de su castillo, arrasando las puertas de su palacio, solo para poder arrancarle la corona a su cadáver. Pero debo ser paciente. La oferta de ese tal Lord N. se hace más jugosa cada día. Promete darme el poder para aniquilar al rey y a sus príncipes, pero sus condiciones... son demasiado altas. No cederé todavía. Esperaré. Al fin y al cabo, nadie tiene suerte para siempre.\"";

  static const String final3Caum =
      "FINAL 3 - CAUM:\n\"'Dejó de hablar'. Eso fue lo que dijo Xaum. Si el Gran Árbol se ha detenido, significa que ha muerto sin nombrar a un sucesor. Todos nos miramos, el miedo echando raíces en nosotros. Zaum dio un paso al frente: 'Debemos empezar con el rito generacional. Como el mayor, ofrezco mi cuerpo'.\nSabíamos lo que significaba. Nos dispusimos a enterrarlo al lado del tronco inerte. Ojalá hubiera sido yo el enterrado... porque ese fue el último día que vi a mis hermanos. El cielo se oscureció. Inmensas bandadas de pájaros monstruosos se apoderaron de las copas, batiendo sus alas y provocando huracanes que nos arrancaban del suelo. Hicieron sus nidos profanos con nuestra tierra y nuestra roca. Y allí, bajo todo ese caos, estaba la semilla de Zaum. Inconsciente. Esperando crecer y madurar. ¿Quién quedó para cuidarlo? Todos cayeron. Solo yo sigo despierto.\"";

  static const String final4Lucien =
      "FINAL 4 - LUCIEN (Resolución Manual):\n\"Ha pasado casi un año desde que los perdí. Finalmente la prensa dejó de acosarme; los ecos de la explosión del laboratorio se han apagado en las calles, pero no en mi cabeza. El servicio intervino, la gente se asustó. Ahora estoy solo.\nDespedí a todos. Me encerré en esta mansión. La vista hacia la ciudad es tan triste... puedo sentir sus miradas sobre mi nuca, esperando que haga algo. He apagado todas las luces. De día y de noche, esta casa parece el esqueleto de un fantasma, con las paredes agrietadas por la explosión y ese enorme agujero en el techo por donde se cuela la lluvia. Nadie vendrá a ver qué pasa; el dueño no acepta visitas. Pero no me rendiré. Debo recuperarlos. Tal vez la alta sociedad diga que no soy tan brillante como Yindosh o Anthon, pero, maldita sea, sigo siendo un científico. Encontraré la forma de traerlos de vuelta.\"";

  // --- VARIABLES DE MEMORIA (El Gacha) ---
  static List<String>? _loreNormal;
  static List<String>? _loreRaro;
  static bool _mensajeVacioMostrado = false;

  // Filtramos y cargamos los datos como balas en un cargador (solo se ejecuta una vez)
  static void _cargarBoveda() {
    if (_loreNormal == null || _loreRaro == null) {
      // Separamos basándonos en la etiqueta "MENSAJE RARO:"
      _loreNormal = Constantes.registroLore
          .where((l) => !l.contains("MENSAJE RARO:"))
          .toList();
      _loreRaro = Constantes.registroLore
          .where((l) => l.contains("MENSAJE RARO:"))
          .toList();

      // Mezclamos ambas listas para que salgan aleatoriamente pero sin repetirse
      _loreNormal!.shuffle();
      _loreRaro!.shuffle();
    }
  }

  static String analizarHistorial(
    List<String> historial,
    Map<String, List<Color>> caras,
  ) {
    if (historial.isEmpty) return "";

    // Aseguramos que la bóveda esté cargada
    _cargarBoveda();

    // 1. ESCÁNER DE FINALES CFOP (Prioridad Máxima)
    for (var entry in secuenciasSecretas.entries) {
      String nombreSecuencia = entry.key;
      List<String> patron = entry.value;

      if (historial.length >= patron.length) {
        List<String> ultimosMovimientos = historial.sublist(
          historial.length - patron.length,
        );
        bool coincidencia = true;
        for (int i = 0; i < patron.length; i++) {
          if (ultimosMovimientos[i] != patron[i]) {
            coincidencia = false;
            break;
          }
        }

        if (coincidencia) {
          historial.clear(); // Evitar spam

          if (nombreSecuencia.contains("Sune")) {
            return "[ANOMALÍA CRÍTICA: $nombreSecuencia]\nAccediendo a registros clasificados...\n\n$final1Wynara";
          } else if (nombreSecuencia == "T-Perm (PLL)" ||
              nombreSecuencia == "J-Perm (PLL)") {
            return "[ANOMALÍA CRÍTICA: $nombreSecuencia]\nAccediendo a registros clasificados...\n\n$final2Sherlock";
          } else if (nombreSecuencia == "Y-Perm (PLL)") {
            return "[ANOMALÍA CRÍTICA: $nombreSecuencia]\nAccediendo a registros clasificados...\n\n$final3Caum";
          }
        }
      }
    }

    // 2. ESCÁNER DE CUBO RESUELTO (Resolución Manual -> Final de Lucien)
    if (_cuboEstaResuelto(caras)) {
      historial.clear();
      return "[ANOMALÍA ABSOLUTA: MATRIZ ESTABILIZADA]\nSincronización manual completada...\n\n$final4Lucien";
    }

    // 3. LA TRAGAPERRAS DEL LORE (Gacha por movimiento)
    // Revisamos si ya consumiste absolutamente todo
    if (_loreNormal!.isEmpty && _loreRaro!.isEmpty) {
      if (!_mensajeVacioMostrado) {
        _mensajeVacioMostrado = true;
        return "[SISTEMA COMPROMETIDO]\n\nFELICIDADES PERDISTE EL TIEMPO YA NO HAY MAS DATOS RESUELVE EL CUBO";
      }
      return ""; // Si ya te insultó, se queda callado hasta que lo resuelvas.
    }

    // Tiramos los dados de 1 a 100
    final random = Random();
    int tirada = random.nextInt(100) + 1;

    // 1% de probabilidad de Lore RARO
    if (tirada == 1) {
      if (_loreRaro!.isNotEmpty) {
        return "[DATOS CORRUPTOS DETECTADOS]\n\n${_loreRaro!.removeLast()}";
      } else if (_loreNormal!.isNotEmpty) {
        // Fallback: si se acabaron los raros, te da uno normal para no perder la tirada
        return "[ANOMALÍA DETECTADA]\n\n${_loreNormal!.removeLast()}";
      }
    }
    // 7% de probabilidad de Lore NORMAL (tiradas del 2 al 8)
    else if (tirada > 1 && tirada <= 8) {
      if (_loreNormal!.isNotEmpty) {
        return "[ANOMALÍA DETECTADA]\n\n${_loreNormal!.removeLast()}";
      } else if (_loreRaro!.isNotEmpty) {
        // Fallback inverso
        return "[DATOS CORRUPTOS DETECTADOS]\n\n${_loreRaro!.removeLast()}";
      }
    }

    // Si la tirada cae del 9 al 100 (92% de las veces), no pasa nada en este movimiento
    return "";
  }

  // Comprueba si el cubo tiene todas las caras del mismo color
  static bool _cuboEstaResuelto(Map<String, List<Color>> caras) {
    for (var cara in caras.values) {
      Color colorBase = cara[0];
      for (int i = 1; i < 9; i++) {
        if (cara[i] != colorBase) return false;
      }
    }
    return true;
  }
}
