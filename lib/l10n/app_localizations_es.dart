// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Asesino Espía - Detector de Cámaras Ocultas';

  @override
  String get privacyPromiseBanner =>
      'Sin cuenta · sin anuncios · sin subida a la nube · sin guardar datos — toda la detección se ejecuta en el dispositivo';

  @override
  String get proTitle => 'Pro';

  @override
  String get proSubtitle =>
      'Archivo de historial ilimitado + funciones avanzadas de IA';

  @override
  String get proUnlock => 'Desbloquear ahora';

  @override
  String get proUnlocked => 'Pro activado';

  @override
  String get proUpgradePrompt =>
      'Actualiza a Pro para obtener historial ilimitado y futuras funciones avanzadas de detección con IA.';

  @override
  String get proPlanMonthly => 'Mensual';

  @override
  String get proPlanYearly => 'Anual';

  @override
  String get proPlanMonthlySub => 'Cancela cuando quieras';

  @override
  String get proPlanYearlySub => 'Mejor precio, 2 meses gratis';

  @override
  String get proBestValue => 'MEJOR PRECIO';

  @override
  String get proRestore => 'Restaurar compras';

  @override
  String get proRestoreEmpty => 'No se encontraron compras anteriores';

  @override
  String get proPurchasing => 'Procesando…';

  @override
  String get proStoreUnavailable =>
      'La tienda no está disponible. Inténtalo de nuevo más tarde.';

  @override
  String get proIapError => 'La compra falló. Inténtalo de nuevo.';

  @override
  String proActiveUntil(Object date) {
    return 'Activo hasta $date';
  }

  @override
  String get proLocalSimUnlock => 'Desarrollador · simular desbloqueo';

  @override
  String get navTabIr => 'IR';

  @override
  String get navTabWifi => 'WiFi';

  @override
  String get navTabMagnet => 'Imán';

  @override
  String get navTabMore => 'Más';

  @override
  String get tabTitleCheck => 'Anti-Cámaras';

  @override
  String get tabTitleIr => 'Detección IR';

  @override
  String get tabTitleWifi => 'Escaneo WiFi';

  @override
  String get tabTitleMagnet => 'Escaneo magnético';

  @override
  String get tabTitleMore => 'Más';

  @override
  String get checkVisualTitle => 'Inspección visual';

  @override
  String get checkVisualDesc =>
      'Revisa espejos, detectores de humo, orificios de enchufes, cuadros, rejillas de aire acondicionado, relojes digitales y otros escondites comunes';

  @override
  String get checkStep1Min => '~1 min';

  @override
  String get checkStep1_5Min => '~1,5 min';

  @override
  String get checkStep2Min => '~2 min';

  @override
  String get checkIrTitle => 'Escaneo IR';

  @override
  String get checkIrDesc =>
      'Apaga las luces, abre «Detección IR» y barre lentamente cada rincón de la habitación';

  @override
  String get checkNetTitle => 'Escaneo de red';

  @override
  String get checkNetDesc =>
      'Conéctate al WiFi de la habitación y abre «Escaneo WiFi» para buscar dispositivos sospechosos';

  @override
  String get checkMagnetTitle => 'Comprobación magnética';

  @override
  String get checkMagnetDesc =>
      'Usa «Escaneo magnético» cerca de cargadores, relojes, detectores de humo y otros objetos sospechosos';

  @override
  String get checkTrackerTitle => 'Escaneo de rastreadores';

  @override
  String get checkTrackerDesc =>
      'Escanea el Bluetooth cercano para detectar rastreadores como AirTags que puedan seguirte';

  @override
  String get checkDone => 'Comprobación completa. Ya puedes relajarte.';

  @override
  String get checkInProgress =>
      'Completa todos los pasos en orden, unos 7 minutos en total';

  @override
  String checkSuspiciousFound(Object count) {
    return 'Se encontraron $count señal(es) sospechosa(s); consulta los siguientes pasos';
  }

  @override
  String get checkNextActions => 'Ver siguientes pasos';

  @override
  String checkStepN(Object n) {
    return 'Paso $n';
  }

  @override
  String get checkHideoutList => 'Lista de escondites';

  @override
  String get checkSkip => 'Omitir';

  @override
  String get checkMarkedSuspicious => 'Marcado como sospechoso';

  @override
  String get checkMarkSuspicious => 'Marcar como sospechoso';

  @override
  String get checkAllFourDone => 'Todos los pasos completados';

  @override
  String get checkAllDoneTip =>
      'Si algún paso mostró una señal sospechosa, toma fotos como evidencia y contacta con la recepción / el arrendador o llama a la policía.';

  @override
  String get nextActionsTitle => 'Encontraste una cámara, qué hacer';

  @override
  String get nextActionsTip =>
      'Mantén la calma, asegura la evidencia primero y no desmontes nada. Tu seguridad personal es lo primero; sal de la habitación de inmediato si es necesario.';

  @override
  String get nextAction1Title => '1. Fotografía la evidencia (hazlo primero)';

  @override
  String get nextAction1Desc =>
      'Usa otro teléfono para fotografiar el dispositivo sospechoso desde varios ángulos, incluyendo su ubicación y la habitación completa. No lo toques, desmontes ni dañes; deja la escena intacta. Es la evidencia clave para denunciar y gestionar el caso.';

  @override
  String get nextAction2Title => '2. Notifica al responsable del lugar';

  @override
  String get nextAction2Desc =>
      'Hoteles/alojamientos: informa de inmediato a la recepción o al arrendador, pide un cambio de habitación o gestión en el lugar y solicita un registro por escrito. Ser grabado en secreto es responsabilidad contractual o incluso legal del establecimiento; nunca negocies en privado sin testigos.';

  @override
  String get nextAction3Title => '3. Llama a la policía';

  @override
  String get nextAction3Desc =>
      'Marca 911 (o el número de emergencias local) y di «sospecho de grabación oculta»; la policía acudirá a recoger la evidencia. Las autoridades pueden hacer análisis forenses; no retires ni destruyas el dispositivo tú mismo.';

  @override
  String get nextActionsRightsTip =>
      'Recordatorio de derechos: en muchos países, la ley prohíbe explícitamente instalar cámaras en espacios privados como hoteles. Puedes exigir una indemnización y presentar una denuncia ante la policía o la asociación de consumidores.';

  @override
  String permissionDenial(Object feature) {
    return 'Se requiere el permiso de $feature para esta función. Actívalo en Ajustes.';
  }

  @override
  String get permissionCameraName => 'Cámara';

  @override
  String get goToSettings => 'Abrir Ajustes';

  @override
  String get irNoCamera => 'No se detectó ninguna cámara';

  @override
  String irInitFailed(Object error) {
    return 'Error al inicializar la cámara: $error';
  }

  @override
  String get irSustainedSummary =>
      'Fuente de luz infrarroja sospechosa persistente (señal clara de iluminador IR)';

  @override
  String get irOccasionalSummary =>
      'Se detectó un punto infrarrojo ocasional (puede ser un mando a distancia / un reflejo)';

  @override
  String get irGuidance =>
      'Apaga las luces y cierra las cortinas. Barre lentamente detectores de humo, enchufes, espejos y otros puntos.';

  @override
  String get torchOn => 'Linterna encendida';

  @override
  String get torchOff => 'Encender linterna';

  @override
  String get irFlipTooltip =>
      'Cambiar cámara (la cámara frontal es más sensible al IR)';

  @override
  String get irResTooltip =>
      'Resolución (más baja = más fotogramas por segundo)';

  @override
  String get irResLow => 'Fluido (480p, mayor velocidad de fotogramas)';

  @override
  String get irResMedium => 'Estándar (720p, recomendado)';

  @override
  String get irResHigh => 'HD (1080p, menor velocidad de fotogramas)';

  @override
  String get irPermTitle => 'Se requiere permiso de cámara';

  @override
  String get irErrorTitle => 'Detección IR no disponible';

  @override
  String get irAlarmBanner =>
      'Fuente de luz IR sospechosa persistente, muévete lentamente y confirma desde varios ángulos';

  @override
  String get irAlertBanner =>
      'Se detectó un punto ocasional; probablemente un mando de TV (IR solo al pulsar botones) o un reflejo; solo los puntos persistentes son sospechosos';

  @override
  String get stabilityChip => 'El dispositivo se está moviendo, mantenlo firme';

  @override
  String get startingCamera => 'Iniciando cámara…';

  @override
  String lensInitFailed(Object error) {
    return 'Error al inicializar la cámara: $error';
  }

  @override
  String get lensConfirmedSummary =>
      'Se encontró un punto sospechoso de reflejo de lente; cambia de ángulo para confirmar';

  @override
  String get lensGuidance =>
      'Mantén la linterna encendida con la luz coaxial a la lente y barre lentamente paredes y objetos';

  @override
  String get lensFlipTooltip => 'Cambiar cámara';

  @override
  String get lensPermTitle => 'Se requiere permiso de cámara';

  @override
  String get lensErrorTitle => 'Escaneo de reflejos no disponible';

  @override
  String get lensConfirmBanner =>
      'Posible reflejo de lente; cambia de ángulo para confirmar';

  @override
  String get lensHintBanner =>
      'Se detectó un punto circular brillante; sigue escaneando para confirmar si es un reflejo (el vidrio/metal puede dar falsos positivos)';

  @override
  String get retry => 'Reintentar';

  @override
  String get wifiNeedInfo =>
      'No se pudo obtener la información del WiFi; asegúrate de estar conectado a una red WiFi';

  @override
  String wifiHighCount(Object count) {
    return '$count dispositivo(s) de alto riesgo';
  }

  @override
  String wifiMediumCount(Object count) {
    return '$count dispositivo(s) sospechoso(s)';
  }

  @override
  String get wifiNoOpenDevices =>
      'No se encontraron dispositivos con puertos de sonda abiertos';

  @override
  String wifiSummary(Object count, Object detail, Object ssid) {
    return 'WiFi $ssid, $count dispositivo(s) encontrado(s). $detail';
  }

  @override
  String get wifiUnknown => 'Desconocido';

  @override
  String wifiVerdictGw(Object gw) {
    return 'No se encontraron dispositivos con puertos de sonda abiertos (la puerta de enlace $gw es accesible). Asegúrate de: la cámara esté en el mismo WiFi y la aislación AP esté desactivada; algunas marcas solo funcionan en la nube por defecto y necesitan acceso local habilitado en su app oficial.';
  }

  @override
  String get wifiVerdictInternet =>
      'La internet pública (1.1.1.1:80) es accesible, pero la LAN no — tu teléfono está aislado o bloqueado de los dispositivos LAN. Causas más comunes: 1) VPN/proxy activado (bloquea la LAN, desactívalo); 2) el teléfono está en la «red de invitados» del router o está activada la «aislación de dispositivos/AP»; 3) el permiso de red local de iOS no ha surtido efecto (Ajustes > Privacidad y seguridad > Red local, asegúrate de que «Asesino Espía» esté en verde; si no, reinicia el teléfono e inténtalo de nuevo).';

  @override
  String get wifiVerdictNone =>
      'Ni la internet pública ni la LAN son accesibles; revisa si el modo avión o una VPN global están activados, o confirma que el WiFi realmente tenga internet.';

  @override
  String get wifiDisclaimer =>
      'Nota: solo se pueden encontrar los dispositivos del WiFi actual; las cámaras sin conexión o con almacenamiento local son invisibles. Los resultados son solo de referencia, no evidencia legal. Mantén presionado un dispositivo para marcarlo rápidamente como «mi dispositivo».';

  @override
  String get wifiNotConnected => 'No conectado a WiFi';

  @override
  String get wifiGettingInfo => 'Obteniendo información de red…';

  @override
  String wifiGatewayMask(Object gateway, Object mask) {
    return 'Puerta de enlace $gateway · Máscara $mask';
  }

  @override
  String get wifiScanning => 'Escaneando subred…';

  @override
  String get wifiStartScan => 'Escanear dispositivos de la LAN';

  @override
  String get wifiResults => 'Resultados del escaneo';

  @override
  String wifiRiskCounts(Object high, Object medium) {
    return '$high de alto riesgo · $medium sospechosos';
  }

  @override
  String get wifiMyDevices => 'Mis dispositivos (marcados)';

  @override
  String get wifiPermTitle => 'Se requiere permiso de ubicación';

  @override
  String get wifiPermDesc =>
      'Android requiere el permiso de ubicación para leer la información del WiFi. Los resultados del escaneo se quedan en tu dispositivo.';

  @override
  String wifiDetailReason(Object reason) {
    return 'Riesgo: $reason';
  }

  @override
  String get wifiDetailIp => 'Dirección IP';

  @override
  String get wifiDetailHostname => 'Nombre del dispositivo';

  @override
  String get wifiDetailMac => 'Dirección MAC';

  @override
  String get wifiDetailVendor => 'Coincidencia de fabricante';

  @override
  String get wifiDetailPorts => 'Puertos abiertos';

  @override
  String get wifiNone => 'Ninguno';

  @override
  String get wifiPortUnknown => 'Desconocido';

  @override
  String get wifiDetailUpnp => 'Descubrimiento UPnP';

  @override
  String get wifiDetailRtsp => 'Huella RTSP';

  @override
  String get wifiDetailHttp => 'Huella HTTP';

  @override
  String get wifiNoMacIos =>
      'iOS no puede leer la dirección MAC, por lo que la información del fabricante no está disponible';

  @override
  String get wifiStaleChip => 'Probablemente en reposo';

  @override
  String get wifiStaleSection => 'En reposo / inaccesibles (historial)';

  @override
  String wifiStaleLastSeen(Object time) {
    return 'Última vez en línea $time';
  }

  @override
  String get wifiStaleNote =>
      'Sin respuesta esta vez; puede estar en reposo. Del último escaneo.';

  @override
  String wifiStaleCount(Object count) {
    return '$count más en reposo / inaccesibles (historial)';
  }

  @override
  String get wifiMarkedCancel => 'Mi dispositivo (toca para desmarcar)';

  @override
  String get wifiMarkAsMine => 'Marcar como mi dispositivo';

  @override
  String get wifiMyDeviceChip => 'Mi dispositivo';

  @override
  String wifiPorts(Object text) {
    return 'Puerto $text';
  }

  @override
  String get wifiNoOpenPort => 'No se encontró ningún puerto abierto';

  @override
  String get bleUnnamed => 'Dispositivo sin nombre';

  @override
  String bleSummary(Object count, Object high, Object medium, Object names) {
    return '$count dispositivo(s) Bluetooth cerca. $high de alto riesgo, $medium sospechosos. $names';
  }

  @override
  String get bleDisclaimer =>
      'Nota: las cámaras Bluetooth son poco comunes; esta herramienta es solo una pista complementaria. Los nombres que contengan palabras clave de cámara/grabadora o los dispositivos sin nombre merecen atención; los auriculares, pulseras y altavoces conectados son dispositivos normales.';

  @override
  String get bleOn => 'Bluetooth activado';

  @override
  String get bleTurningOn => 'Activando…';

  @override
  String get bleOff => 'Bluetooth desactivado';

  @override
  String get bleOnDesc => 'Listo para escanear dispositivos cercanos';

  @override
  String get bleOffDesc => 'El Bluetooth debe estar activado para escanear';

  @override
  String get bleTurnOn => 'Activar';

  @override
  String get bleScanning => 'Escaneando (unos 5 s)…';

  @override
  String get bleStartScan => 'Escanear dispositivos Bluetooth cercanos';

  @override
  String get bleRiskHigh => 'Alto riesgo';

  @override
  String get bleRiskMedium => 'Sospechoso';

  @override
  String get bleRiskLow => 'Riesgo bajo';

  @override
  String magnetSummary(Object delta, Object threshold) {
    return 'Variación de campo $delta µT sobre el ambiente, supera el umbral de $threshold µT';
  }

  @override
  String get magnetUsageTitle => 'Consejos de uso';

  @override
  String get magnetTip1 =>
      '• Sostén el teléfono a 3~10 cm del objeto sospechoso y muévete lentamente';

  @override
  String get magnetTip2 =>
      '• Ubicación del magnetómetro: cerca de la esquina superior derecha en iPhone, cerca del centro superior en la mayoría de teléfonos Android';

  @override
  String get magnetTip3 =>
      '• Actúa solo cuando supere la línea del umbral durante más de 1 segundo';

  @override
  String get magnetTip4 =>
      '• Las zonas con electrónica densa (paredes de enchufes, cerca de routers) generan más falsos positivos';

  @override
  String get magnetCalibrating =>
      'Calibrando el campo magnético ambiental (mantén el teléfono quieto)…';

  @override
  String get magnetCalibrated =>
      'Calibrado, ya puedes escanear objetos sospechosos';

  @override
  String get magnetRecalibrate => 'Recalibrar';

  @override
  String get magnetAlarm => '¡Anomalía magnética detectada, confírmala!';

  @override
  String get magnetDelta => 'Variación respecto al ambiente';

  @override
  String magnetThresholdValue(Object value) {
    return 'Umbral $value µT';
  }

  @override
  String get magnetThresholdTitle => 'Umbral de alarma';

  @override
  String get magnetThresholdHint =>
      'Súbelo para reducir falsos positivos (bájalo para escenas más sensibles)';

  @override
  String get magnetChart => 'Gráfico en vivo';

  @override
  String get moreTools => 'Herramientas de detección';

  @override
  String get moreLensTitle => 'Escaneo de reflejos de lente';

  @override
  String get moreLensSubtitle =>
      'Luz coaxial de la linterna para encontrar reflejos de lentes';

  @override
  String get moreBleTitle => 'Escaneo Bluetooth';

  @override
  String get moreBleSubtitle =>
      'Escaneo complementario de dispositivos Bluetooth cercanos';

  @override
  String get moreReportTitle => 'Informe de inspección';

  @override
  String get moreReportSubtitle =>
      'Resume los resultados y expórtalos como PDF';

  @override
  String get moreHistoryTitle => 'Historial de escaneos';

  @override
  String get moreHistorySubtitle =>
      'Registros y fotos guardados de las inspecciones';

  @override
  String get moreGuide => 'Guía de escondites';

  @override
  String get moreGuideSubtitle =>
      'Lugares comunes de ocultamiento y consejos anti-cámaras';

  @override
  String get guideTitle => 'Guía de inspección';

  @override
  String get guideIntro =>
      'Primero revisa con la vista, luego verifica cada punto con las herramientas. A continuación los escondites más comunes: repásalos en orden.';

  @override
  String get guideCta =>
      '¿Encontraste algo sospechoso? Consulta los siguientes pasos';

  @override
  String get guideHow => 'Cómo revisar: ';

  @override
  String get guideHint => 'Consejo: ';

  @override
  String get guideP1Title => 'Detector de humo';

  @override
  String get guideP1Check =>
      'Ponte justo debajo y mira hacia arriba / desde el lateral; los orificios pequeños suelen ocultarse en las juntas de metal y plástico';

  @override
  String get guideP1Hint =>
      'Las carcasas negras ocultan fácilmente lentes de orificio pequeño: acércate y revisa varios ángulos';

  @override
  String get guideP2Title => 'Enchufes y regletas';

  @override
  String get guideP2Check =>
      'Busca agujeros o protuberancias anormales en el panel; ilumina el interior con una linterna';

  @override
  String get guideP2Hint =>
      'Los puertos USB, los orificios de cargadores y los laterales de las regletas son escondites comunes';

  @override
  String get guideP3Title => 'Espejo (de doble vía)';

  @override
  String get guideP3Check =>
      'Pon una uña sobre el vidrio: si hay separación es un espejo normal; si no hay separación, ten cuidado';

  @override
  String get guideP3Hint =>
      'Un espejo de doble vía puede ocultar una habitación detrás — pero el propio espejo también puede contener una microlente';

  @override
  String get guideP4Title => 'Cuadros y marcos';

  @override
  String get guideP4Check =>
      'Revisa los bordes del marco y el espacio detrás del cuadro buscando agujeros extra';

  @override
  String get guideP4Hint =>
      'Los compartimentos ocultos detrás de los marcos son clásicos: presiona suavemente el marco para detectar anomalías';

  @override
  String get guideP5Title => 'Rejillas de aire acondicionado';

  @override
  String get guideP5Check =>
      'Ilumina la rejilla con una linterna y busca reflejos inusuales entre las aletas';

  @override
  String get guideP5Hint =>
      'El espacio entre un AC de pared y la pared puede ocultar microdispositivos';

  @override
  String get guideP6Title => 'Reloj / lámpara de noche';

  @override
  String get guideP6Check =>
      'Revisa la pantalla, las juntas de los botones y la base buscando agujeros extra';

  @override
  String get guideP6Hint =>
      'Los dispositivos junto a la cama están ocultos y muy cerca de ti — revísalos primero';

  @override
  String get guideP7Title => 'Router / caja de TV';

  @override
  String get guideP7Check =>
      'Busca LEDs o agujeros adicionales más allá de las luces normales';

  @override
  String get guideP7Hint =>
      'Los routers suelen usarse como disfraz «legítimo» para una cámara';

  @override
  String get guideP8Title => 'Macetas';

  @override
  String get guideP8Check =>
      'Revisa la maceta y el follaje sobre la tierra buscando objetos extraños';

  @override
  String get guideP8Hint =>
      'Las microlentes bajo el follaje son difíciles de ver — combínalo con el escaneo IR';

  @override
  String get guideP9Title => 'Luces / detector de humo';

  @override
  String get guideP9Check =>
      'Revisa dentro de las pantallas de lámparas, juntas de candelabros y detrás de lámparas de pared';

  @override
  String get guideP9Hint =>
      'El resplandor cerca de las fuentes de luz engaña al ojo — el detector IR es más fiable aquí';

  @override
  String get guideP10Title => 'AirTag / rastreadores Bluetooth';

  @override
  String get guideP10Check =>
      'Abre el Escaneo de rastreadores para escanear el Bluetooth cercano; escanea varias veces desde distintos lugares para comprobar si algún dispositivo sigue siguiéndote';

  @override
  String get guideP10Hint =>
      'Los rastreadores suelen ocultarse en bolsos, equipaje y coches; mantén habilitadas las alertas integradas del sistema para rastreadores desconocidos';

  @override
  String get quickScanTitle => 'Escaneo rápido';

  @override
  String get quickScanSubtitle =>
      'IR → WiFi → Imán → Rastreadores, totalmente automatizado';

  @override
  String get quickScanStepIr => 'Escaneo IR (≈ 20 s)';

  @override
  String get quickScanStepWifi => 'Escaneo WiFi (≈ 15 s)';

  @override
  String get quickScanStepMagnet => 'Escaneo magnético (≈ 15 s)';

  @override
  String get quickScanStepTracker => 'Escaneo de rastreadores (≈ 10 s)';

  @override
  String get quickScanDone =>
      'Escaneo rápido completado. Consulta el veredicto.';

  @override
  String quickScanRunning(Object step) {
    return 'Ejecutando: $step';
  }

  @override
  String get quickScanStart => 'Iniciar escaneo rápido';

  @override
  String get verdictTitle => 'Veredicto del escaneo';

  @override
  String get verdictSafe => 'Seguro: no se encontraron señales sospechosas';

  @override
  String get verdictHighRisk => 'Alto riesgo: posible cámara oculta';

  @override
  String verdictRisk(Object count) {
    return 'Se encontró riesgo: $count elemento(s) sospechoso(s)';
  }

  @override
  String get verdictViewEvidence => 'Ver evidencia';

  @override
  String get verdictExportPdf => 'Exportar PDF';

  @override
  String get verdictNextActions => 'Siguientes pasos';

  @override
  String get verdictDone => 'Listo';

  @override
  String get morePrivacy => 'Política de privacidad';

  @override
  String get morePrivacySubtitle =>
      'Sin cuenta · sin anuncios · sin subida a la nube · sin guardar datos';

  @override
  String get moreAbout => 'Acerca de';

  @override
  String get moreAboutSubtitle => 'Versión 1.0.0';

  @override
  String get moreSettings => 'Ajustes';

  @override
  String get moreSettingsSubtitle => 'Idioma · estadísticas locales · datos';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Seguir sistema';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsStatsTitle => 'Estadísticas locales';

  @override
  String get statsCheckStarted => 'Comprobaciones iniciadas';

  @override
  String get statsCheckDone => 'Comprobaciones completadas';

  @override
  String get statsCompletionRate => 'Tasa de finalización';

  @override
  String get statsAvgDuration => 'Duración media';

  @override
  String get statsTools => 'Uso de herramientas';

  @override
  String get statsEmpty =>
      'Aún no hay datos. Completa una revisión de habitación o usa una herramienta de detección y se registrará aquí (solo en el dispositivo).';

  @override
  String statsDurationFormat(Object m, Object s) {
    return '${m}m ${s}s';
  }

  @override
  String get settingsDataTitle => 'Datos';

  @override
  String get settingsClearStats => 'Borrar estadísticas locales';

  @override
  String get settingsClearReport => 'Borrar registros de revisión';

  @override
  String get settingsClearConfirm => 'Esto no se puede deshacer. ¿Continuar?';

  @override
  String get settingsClearDone => 'Borrar';

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsDataNote =>
      'Todas las estadísticas se almacenan solo en este dispositivo y nunca se suben. El historial de escaneos se guarda en el dispositivo; la versión gratuita conserva los últimos 5 registros.';

  @override
  String get morePrivacyDesign => 'Diseño centrado en la privacidad';

  @override
  String get morePrivacyDesc =>
      'Toda la detección se ejecuta en el dispositivo: sin cuenta, sin recopilación, sin subida de imágenes ni datos de red.';

  @override
  String get reportTitle => 'Informe de inspección';

  @override
  String get reportHistoryTitle => 'Historial de escaneos';

  @override
  String get reportOpenHistory => 'Ver todo';

  @override
  String get reportSeal => 'Finalizar y guardar esta revisión';

  @override
  String get historyTitle => 'Historial de escaneos';

  @override
  String get historyEmpty =>
      'Aún no hay revisiones guardadas. Termina una revisión y toca «Finalizar y guardar esta revisión» en la pantalla de Informe para archivarla.';

  @override
  String historyProNote(Object count) {
    return 'La versión gratuita conserva los últimos $count registros de escaneo. Actualiza a Pro para almacenamiento ilimitado';
  }

  @override
  String get historyProUnlimited => 'Pro: historial de escaneos ilimitado';

  @override
  String historyPlace(Object place) {
    return 'Lugar: $place';
  }

  @override
  String get historyOpen => 'Abrir';

  @override
  String get historyDelete => 'Eliminar';

  @override
  String get historyDeleteConfirm =>
      '¿Eliminar este registro de escaneo? Sus detalles y fotos se eliminarán permanentemente.';

  @override
  String get reportEmptyError =>
      'Aún no hay registros de inspección; completa al menos una detección primero';

  @override
  String get reportShareCancelled => 'Compartición cancelada';

  @override
  String reportExportFailed(Object error) {
    return 'Error al exportar: $error';
  }

  @override
  String get reportPlaceLabel =>
      'Lugar de inspección (opcional, ej. hotel / n.º de habitación)';

  @override
  String get reportPlaceHint =>
      'Solo se muestra en el informe, sin acceso a la ubicación';

  @override
  String get reportPhotos => 'Fotos';

  @override
  String get reportPhotosEmpty =>
      'Aún no hay fotos. Fotografía los dispositivos o puntos sospechosos; se incluirán al exportar.';

  @override
  String get reportAddPhoto => 'Añadir foto';

  @override
  String get reportAddPhotoCamera => 'Tomar foto';

  @override
  String get reportAddPhotoGallery => 'Elegir de la galería';

  @override
  String get reportPhotoFailed =>
      'No se pudo añadir la foto, inténtalo de nuevo';

  @override
  String get reportEmptyHint =>
      'Aún no hay registros. Los resultados se resumen aquí automáticamente después de los escaneos IR, de reflejos, WiFi, Bluetooth o magnético.';

  @override
  String get reportDetails => 'Detalles';

  @override
  String get reportClear => 'Borrar';

  @override
  String get reportExporting => 'Generando PDF…';

  @override
  String get reportExportPdf => 'Exportar PDF y compartir';

  @override
  String get reportLocalNote =>
      'El informe se genera en el dispositivo y se comparte a través de la hoja del sistema; no se sube nada. Esta revisión se guarda en el dispositivo (la versión gratuita conserva los últimos 5).';

  @override
  String reportSummary(Object count, Object riskCount) {
    return '$count comprobación(es) · $riskCount riesgo(s)/incierto(s)';
  }

  @override
  String get reportSummaryDesc =>
      'Resumen de las comprobaciones de esta sesión, exportable como PDF';

  @override
  String get reportPdfTitle => 'Asesino Espía · Informe de inspección';

  @override
  String get reportPdfTime => 'Generado el';

  @override
  String get reportPdfPlace => 'Lugar de inspección';

  @override
  String get reportPdfPlaceEmpty => 'No especificado';

  @override
  String get reportPdfWifi => 'WiFi';

  @override
  String get reportPdfWifiEmpty => 'No conectado a WiFi';

  @override
  String get reportPdfPhotos => 'Fotos';

  @override
  String reportPdfSummary(Object count, Object risk) {
    return '$count comprobación(es) en total, $risk marcada(s) como riesgo/incierta(s). Solo como referencia, no es evidencia legal.';
  }

  @override
  String get reportPdfEmpty => 'No hay registros de inspección en esta sesión.';

  @override
  String get reportPdfNext => 'Siguientes pasos sugeridos';

  @override
  String get reportPdfAction1 =>
      'Fotografía la ubicación del dispositivo sospechoso y la vista general de la habitación; no lo toques ni lo desmontes';

  @override
  String get reportPdfAction2 =>
      'Informa a la recepción del hotel / al arrendador y solicita un registro por escrito o un cambio de habitación';

  @override
  String get reportPdfAction3 =>
      'Llama a la policía (911) para el análisis forense en el lugar';

  @override
  String get reportPdfDisclaimer =>
      'Aviso: la detección IR/de reflejos depende de la sensibilidad IR del CMOS de tu teléfono; el escaneo WiFi solo encuentra dispositivos en la LAN actual; las comprobaciones magnética y Bluetooth son complementarias. Este informe no es evidencia legal; confía en el análisis policial.';

  @override
  String get reportPdfFooter =>
      'Generado por «Asesino Espía» · procesado solo en el dispositivo';

  @override
  String get riskSafe => 'Aprobado';

  @override
  String get riskLow => 'Incierto';

  @override
  String get riskHigh => 'Riesgo';

  @override
  String get featureIr => 'Detección IR';

  @override
  String get featureLens => 'Escaneo de reflejos de lente';

  @override
  String get featureWifi => 'Escaneo de red WiFi';

  @override
  String get featureBluetooth => 'Escaneo Bluetooth';

  @override
  String get featureMagnet => 'Escaneo magnético';

  @override
  String get featureTracker => 'Escaneo de rastreadores';

  @override
  String get navTabHub => 'Anti-Espionaje';

  @override
  String get tabTitleHub => 'Anti-Vigilancia';

  @override
  String get hubTagline =>
      'Encuentra cámaras ocultas en tu habitación y rastreadores que te siguen';

  @override
  String get hubTaglineSub =>
      'Anti-cámaras · anti-seguimiento, todo en el dispositivo';

  @override
  String get hubRoomCheckTitle => 'Anti-Cámaras';

  @override
  String get hubRoomCheckSubtitle =>
      'Escaneo de 4 pasos para cámaras ocultas (IR / lente / WiFi / imán)';

  @override
  String get hubTrackerTitle => 'Escaneo de rastreadores';

  @override
  String get hubTrackerSubtitle =>
      'Escanea Bluetooth cercano para detectar rastreadores que te siguen';

  @override
  String get trackerTitle => 'Escaneo de rastreadores';

  @override
  String get trackerIntro =>
      'Escanea los dispositivos Bluetooth cercanos en busca de rastreadores conocidos como AirTags. Escanea varias veces desde distintos lugares para comprobar si algún dispositivo sigue siguiéndote. Todo se queda en tu dispositivo.';

  @override
  String get trackerStartScan => 'Iniciar escaneo';

  @override
  String get trackerScanning => 'Escaneando (unos 10 s)…';

  @override
  String get trackerScanAgain => 'Escanear de nuevo';

  @override
  String get trackerScanFailed =>
      'El escaneo falló. Asegúrate de que el permiso de Bluetooth esté concedido e inténtalo de nuevo.';

  @override
  String trackerRoundsDone(Object count) {
    return '$count escaneo(s) completado(s)';
  }

  @override
  String get trackerRoundsTip =>
      'Muévete a otro lugar o sal fuera y escanea de nuevo para confirmar si un dispositivo sigue siguiéndote.';

  @override
  String get trackerMoveHint =>
      'Se encontraron candidatos a rastreadores. Confirma su ubicación o escanea de nuevo para más certeza.';

  @override
  String get trackerFinish => 'Finalizar revisión';

  @override
  String get trackerRestart => 'Empezar de nuevo';

  @override
  String get trackerNoTracker => 'No se encontraron rastreadores conocidos';

  @override
  String get trackerNoTrackerTip =>
      'Sigue confiando en las alertas integradas del sistema sobre rastreadores desconocidos y mantente alerta.';

  @override
  String trackerFoundCandidates(Object count) {
    return '$count candidato(s) encontrado(s)';
  }

  @override
  String get trackerSectionTrackers => 'Candidatos a rastreador';

  @override
  String trackerSectionOthers(Object count) {
    return 'Otros dispositivos Bluetooth ($count)';
  }

  @override
  String get trackerBrandFindMy => 'AirTag / accesorio de Buscar';

  @override
  String get trackerBrandSamsung => 'Samsung SmartTag';

  @override
  String get trackerBrandTile => 'Rastreador Tile';

  @override
  String get trackerBrandGoogle => 'Rastreador de Google';

  @override
  String get trackerMotionRepeated => 'Posiblemente te sigue';

  @override
  String get trackerMotionOnce => 'Visto una vez';

  @override
  String get trackerMotionRegular => 'Dispositivo habitual';

  @override
  String get trackerDistanceNear => 'Muy cerca';

  @override
  String get trackerDistanceMid => 'Cerca';

  @override
  String get trackerDistanceFar => 'Lejos';

  @override
  String get trackerGuidanceTitle =>
      'Se encontró un rastreador sospechoso, qué hacer';

  @override
  String get trackerGuidance1 =>
      'Revisa tus pertenencias, bolsos y el interior/exterior de tu vehículo en busca de dispositivos pequeños desconocidos';

  @override
  String get trackerGuidance2 =>
      'Para un AirTag, abre la app Buscar en cualquier iPhone cercano → Objetos e intenta reproducir un sonido para localizarlo';

  @override
  String get trackerGuidance3 =>
      'No lo retires a la ligera — primero fotografía la evidencia; si se confirma, contacta con la policía';

  @override
  String get trackerDisclaimer =>
      'Nota: este escaneo se ejecuta en primer plano y solo reconoce marcas de rastreadores conocidas. Es posible que los dispositivos emparejados activamente con el teléfono de su dueño no se detecten. Los resultados son solo de referencia, no evidencia legal.';

  @override
  String get trackerSafeTitle => 'Nada inusual';

  @override
  String get trackerSafeDesc =>
      'No se encontraron rastreadores conocidos en esta ronda. Mantente alerta y vuelve a escanear desde otro lugar si es necesario.';

  @override
  String get trackerRiskTitle => 'Se encontraron candidatos a rastreadores';

  @override
  String trackerRiskRepeated(Object count) {
    return '$count dispositivo(s) siguieron apareciendo cerca de ti en los escaneos — revisa ahora';
  }

  @override
  String trackerRiskOnce(Object count) {
    return 'Se encontraron $count candidato(s) a rastreador — sigue la guía de abajo';
  }

  @override
  String trackerReportSummary(
    Object candidates,
    Object repeated,
    Object rounds,
  ) {
    return 'Escaneo de rastreadores $rounds vez/veces: $candidates candidato(s), $repeated posiblemente te siguen';
  }

  @override
  String get trackerReportSummaryNone =>
      'El escaneo de rastreadores no encontró rastreadores conocidos';

  @override
  String get moreTrackerTitle => 'Escaneo de rastreadores';

  @override
  String get moreTrackerSubtitle =>
      'Detecta AirTags, SmartTags y otros rastreadores cercanos';
}
