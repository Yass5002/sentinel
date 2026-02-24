// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SENTINEL';

  @override
  String get alertsSent => 'ALERTAS ENVIADAS';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get pending => 'PENDIENTE';

  @override
  String get recipients => 'DESTINATARIOS';

  @override
  String get noContacts => 'SIN CONTACTOS';

  @override
  String get details => 'DETALLES';

  @override
  String get cancelEvent => 'CANCELAR EVENTO';

  @override
  String get cancelEventTitle => '¿CANCELAR EVENTO?';

  @override
  String get cancelEventBody =>
      'Esto cancelará el evento y no se enviarán alertas.';

  @override
  String get keepButton => 'MANTENER';

  @override
  String get iAmSafe => 'ESTOY A SALVO';

  @override
  String get returnToHome => 'VOLVER AL INICIO';

  @override
  String get tracking => 'Rastreando';

  @override
  String get locationOff => 'Ubicación desactivada';

  @override
  String get locationLimited => 'Limitado';

  @override
  String get locationTrackingOffBanner =>
      'El rastreo de ubicación está desactivado. Actívelo en Configuración.';

  @override
  String get locationDeniedBanner =>
      'La ubicación está desactivada. Sus contactos no recibirán su ubicación.';

  @override
  String get locationLimitedBanner =>
      'La ubicación en segundo plano es limitada. Es posible que sus contactos no reciban su última ubicación.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get noMessage => 'No se proporcionó ningún mensaje.';

  @override
  String filesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos',
      one: '1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get settings => 'CONFIGURACIÓN';

  @override
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get notifications => 'NOTIFICACIONES';

  @override
  String get checkInReminders => 'Recordatorios de check-in';

  @override
  String get checkInRemindersSub =>
      'Reciba alertas 1h, 15m y 5m antes de que expiren sus Centinelas.';

  @override
  String get location => 'UBICACIÓN';

  @override
  String get locationTracking => 'Rastreo de ubicación';

  @override
  String get locationTrackingSub =>
      'Comparta su ubicación con contactos de emergencia mientras los eventos estén activos.';

  @override
  String get locationBlocked =>
      'El acceso a la ubicación está bloqueado por la configuración de su dispositivo';

  @override
  String get account => 'CUENTA';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get logOutConfirmBody => '¿Está seguro de que desea cerrar sesión?';

  @override
  String get dangerZone => 'ZONA DE PELIGRO';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirmBody =>
      '¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer y todos sus datos se eliminarán permanentemente.';

  @override
  String get deleting => 'Eliminando...';

  @override
  String get about => 'ACERCA DE';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get neverMissCheckIn => 'Nunca te pierdas un check-in';

  @override
  String get notificationPrimer =>
      'SENTINEL necesita permisos de notificación para alertarlo antes de que expiren sus Centinelas. Sin esto, no recibirá las alertas cruciales de cuenta regresiva de 1h, 15m y 5m.';

  @override
  String get notNow => 'Ahora no';

  @override
  String get enableNotifications => 'Habilitar notificaciones';

  @override
  String get shareLocationTitle => 'Comparta su ubicación con contactos';

  @override
  String get shareLocationBody =>
      'Si no hace check-in, SENTINEL envía su última ubicación conocida a sus contactos de emergencia para que puedan encontrarlo. La ubicación solo se rastrea mientras tiene un evento activo.';

  @override
  String get enableLocation => 'Habilitar ubicación';

  @override
  String get allowBackgroundLocation => 'Permitir ubicación en segundo plano';

  @override
  String get backgroundLocationBody =>
      'Por su seguridad, permita el acceso a la ubicación \"Todo el tiempo\" en la siguiente pantalla. Esto garantiza que el rastreo continúe incluso cuando su teléfono esté bloqueado.';

  @override
  String get skip => 'Omitir';

  @override
  String get continueText => 'Continuar';

  @override
  String get noEventCreated => 'NINGÚN EVENTO CREADO AÚN';

  @override
  String get loadMore => 'CARGAR MÁS';

  @override
  String get cancel => 'Cancelar';

  @override
  String get loginTitle => 'Ingresa tu correo electrónico para comenzar';

  @override
  String get emailHint => 'Correo electrónico';

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get emailInvalid =>
      'Por favor, introduce un correo electrónico válido';

  @override
  String get getStarted => 'COMENZAR';

  @override
  String get checkEmail => 'Revisa tu correo electrónico';

  @override
  String codeSentTo(String email) {
    return 'Enviamos un código de 6 dígitos a $email';
  }

  @override
  String get verify => 'VERIFICAR';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String resendCodeIn(int seconds) {
    return 'Reenviar código en ${seconds}s';
  }

  @override
  String get codeSent => 'Código enviado';

  @override
  String get profile => 'PERFIL';

  @override
  String get memberSince => 'MIEMBRO DESDE';

  @override
  String get editNameTitle => 'Editar nombre';

  @override
  String get nameHint => 'Nombre';

  @override
  String get save => 'Guardar';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get helpQ1 => '¿Qué es SENTINEL?';

  @override
  String get helpA1 =>
      'SENTINEL es su compañero de seguridad personal. Le permite configurar un temporizador y, si no se registra antes de que expire, alerta automáticamente a sus contactos de emergencia con su última ubicación conocida y un mensaje personalizado.';

  @override
  String get helpQ2 => '¿Cómo creo un nuevo SENTINEL?';

  @override
  String get helpA2 =>
      'Toque el botón \'+\' en la pantalla de inicio. Establezca una duración (por ejemplo, 30 minutos), agregue notas o archivos y seleccione sus contactos de emergencia. Toque \'Iniciar SENTINEL\' para comenzar.';

  @override
  String get helpQ3 => '¿Qué sucede cuando expira el temporizador?';

  @override
  String get helpA3 =>
      'Cuando el temporizador llega a cero, SENTINEL notifica inmediatamente a todos sus contactos de emergencia seleccionados por SMS/correo electrónico. Recibirán su mensaje personalizado y un enlace para ver su última ubicación conocida en un mapa.';

  @override
  String get helpQ4 => '¿Qué es un \'Check-In\'?';

  @override
  String get helpA4 =>
      'Registrarse cancela la cuenta regresiva activa. Utilice esto una vez que esté seguro o ya no necesite el SENTINEL. Si se registra, no se enviarán alertas.';

  @override
  String get helpQ5 => '¿Puedo extender un temporizador activo?';

  @override
  String get helpA5 =>
      '¡Sí! Toque su SENTINEL activo y use el botón \'Extender\' para agregar más tiempo si su situación cambia.';

  @override
  String get helpQ6 => '¿Quiénes son los contactos de emergencia?';

  @override
  String get helpA6 =>
      'Los contactos de emergencia son personas en las que confía. Debe seleccionar al menos un contacto para cada SENTINEL. Puede administrar sus contactos en la pantalla \'Contactos\' accesible desde el menú lateral.';

  @override
  String get helpQ7 => '¿SENTINEL rastrea mi ubicación?';

  @override
  String get helpA7 =>
      'SENTINEL SOLO rastrea su ubicación mientras un temporizador está activo. Valoramos su privacidad y no controlamos sus movimientos cuando la aplicación está inactiva o no hay SENTINELs en ejecución.';

  @override
  String get helpQ8 => '¿Qué pasa si no tengo internet?';

  @override
  String get helpA8 =>
      'SENTINEL requiere una conexión a Internet para iniciar un evento y cargar datos. Si pierde la conexión durante un evento activo, la cuenta regresiva en nuestros servidores aún activará la alerta a menos que se registre.';

  @override
  String get helpQ9 => '¿Cuántos contactos puedo agregar?';

  @override
  String get helpA9 =>
      'Puede agregar hasta 10 contactos de emergencia por evento SENTINEL.';

  @override
  String get helpQ10 => '¿Mis datos están seguros?';

  @override
  String get helpA10 =>
      'Sí, sus datos personales y su ubicación están cifrados. Solo los contactos de emergencia que especifique pueden ver su ubicación, y solo después de que se active una alerta.';

  @override
  String get helpQ11 => '¿Puedo agregar fotos o grabaciones?';

  @override
  String get helpA11 =>
      '¡Sí! Al crear un SENTINEL, puede adjuntar archivos. Estos se compartirán con sus contactos si se activa la alerta, proporcionando más contexto sobre su situación.';

  @override
  String get helpQ12 => '¿Qué es el botón \'ESTOY SEGURO\'?';

  @override
  String get helpA12 =>
      'Este es su botón de registro. Al tocarlo, le dice a SENTINEL que está bien, lo que detiene inmediatamente la cuenta regresiva y evita que se envíen alertas.';

  @override
  String get helpQ13 => '¿La aplicación debe estar abierta?';

  @override
  String get helpA13 =>
      'No. SENTINEL ejecuta su cuenta regresiva crítica en nuestros servidores seguros. Incluso si su teléfono se apaga, se queda sin batería o se destruye, la alerta se enviará cuando expire el temporizador.';

  @override
  String get helpQ14 => '¿Cómo administro mi perfil?';

  @override
  String get helpA14 =>
      'Puede actualizar su nombre y ver los detalles de su cuenta en la sección \'Perfil\', accesible desde el menú lateral de la aplicación.';

  @override
  String get helpQ15 => '¿Qué pasa si activo una alerta por error?';

  @override
  String get helpA15 =>
      'Si se envía una alerta, sus contactos serán notificados. Recomendamos contactarlos inmediatamente para informarles que fue una falsa alarma. Intente siempre registrarse ANTES de que el temporizador llegue a cero.';

  @override
  String get contactSupport => 'Contactar con Soporte';

  @override
  String get contactSupportText =>
      'Si tiene algún problema o sugerencia, póngase en contacto con nosotros en:';

  @override
  String get loading => 'Cargando...';

  @override
  String get home => 'Inicio';

  @override
  String get contacts => 'Contactos';

  @override
  String get checkedIn => 'Registrado';

  @override
  String get created => 'Creado';

  @override
  String get deleteEvent => 'Eliminar evento';

  @override
  String get deleteEventHistoryConfirm =>
      '¿Está seguro de que desea eliminar todo el historial de eventos?';

  @override
  String get delete => 'Eliminar';

  @override
  String get failedToLoadEvents => 'Error al cargar eventos';

  @override
  String get failedToLoadEventDetails =>
      'Error al cargar los detalles del evento';

  @override
  String get messageTitle => 'Mensaje';

  @override
  String get attachments => 'Adjuntos';

  @override
  String get newSentinel => 'Nuevo SENTINEL';

  @override
  String get eventName => 'Nombre del evento';

  @override
  String get timer => 'Temporizador';

  @override
  String get enterMessage =>
      'Ingrese el mensaje a enviar si el temporizador expira...';

  @override
  String get addFile => 'Agregar archivo';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get initiateSentinel => 'Iniciar SENTINEL';

  @override
  String get addContact => 'Agregar contacto';

  @override
  String get selectContacts => 'Seleccionar contactos';

  @override
  String get savedContacts => 'Contactos guardados';

  @override
  String contactsSelected(int count) {
    return 'Contactos seleccionados: $count';
  }

  @override
  String get searchContacts => 'Buscar contactos...';

  @override
  String get orEnterManually => 'O INGRESAR MANUALMENTE';

  @override
  String get enterContactManually => 'INGRESAR CONTACTO MANUALMENTE';

  @override
  String get emailExample => 'correo@ejemplo.com';

  @override
  String get contactNameOptional => 'Nombre del contacto (opcional)';

  @override
  String get selectAtLeastOneContact =>
      'Por favor seleccione al menos un contacto';

  @override
  String get maxContactsAllowed => 'Máximo 10 contactos permitidos';

  @override
  String get duration => 'Duración';

  @override
  String get date => 'Fecha';

  @override
  String get noRecipients => 'Sin destinatarios';

  @override
  String get safe => 'Seguro';

  @override
  String get active => 'Activo';

  @override
  String failedToOpenFile(String message) {
    return 'Error al abrir el archivo: $message';
  }

  @override
  String get failedToDownloadFile => 'Error al descargar el archivo';

  @override
  String get failedToDeleteAccount => 'Error al eliminar la cuenta';

  @override
  String get language => 'Idioma';

  @override
  String get noEventCreatedYet => 'AÚN NO SE HA CREADO NINGÚN EVENTO';

  @override
  String get somethingWentWrong => '¡Algo salió mal!';

  @override
  String get retry => 'Reintentar';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get arabic => 'Árabe';

  @override
  String get chinese => 'Chino';

  @override
  String get unknown => 'Desconocido';

  @override
  String get none => 'NINGUNO';

  @override
  String get days => 'd';

  @override
  String get notifTitle => 'SENTINEL';

  @override
  String get notifAlertTitle => 'Alerta de SENTINEL';

  @override
  String notifHourBody(Object eventName) {
    return 'Tu SENTINEL \'$eventName\' vence en 1 hora';
  }

  @override
  String notifFifteenMinBody(Object eventName) {
    return 'Tu SENTINEL \'$eventName\' vence en 15 minutos';
  }

  @override
  String notifFiveMinBody(Object eventName) {
    return 'Tu SENTINEL \'$eventName\' vence en 5 minutos. Regístrate ahora.';
  }

  @override
  String notifFiredBody(Object eventName) {
    return 'El SENTINEL \'$eventName\' se ha activado. Tus contactos de emergencia han sido notificados.';
  }

  @override
  String get notifCountdownBody =>
      'Las alertas de emergencia se activarán cuando el temporizador llegue a cero. Toca para registrarte.';

  @override
  String get notifTrackingTitle => 'Seguimiento de ubicación';

  @override
  String get notifTrackingBody => 'SENTINEL está rastreando tu ubicación';

  @override
  String get notifTrackingDesc =>
      'Muestra cuándo SENTINEL está rastreando tu ubicación';

  @override
  String get notifCountdownChannelName => 'Cuenta regresiva de SENTINEL';

  @override
  String get notifCountdownChannelDesc =>
      'Muestra el temporizador de cuenta regresiva activo';

  @override
  String get sentinelBrand => 'SENTINEL';

  @override
  String get contactNameHint => 'Nombre del contacto';

  @override
  String get noSavedContacts => 'No hay contactos guardados';

  @override
  String get deleteContactTitle => 'Eliminar contacto';

  @override
  String get deleteContactConfirm => 'se eliminará de sus contactos guardados.';

  @override
  String get failedToLoadContacts => 'Error al cargar los contactos';

  @override
  String get contactEmailLabel => 'EMAIL';

  @override
  String get contactNameLabel => 'NOMBRE (OPCIONAL)';

  @override
  String get contactAlreadyExists =>
      'Ya existe un contacto con este correo electrónico';

  @override
  String get unableToLoadProfile => 'No se puede cargar el perfil';

  @override
  String get setYourName => 'Establezca su nombre';

  @override
  String get nameVisibleToContacts =>
      'Este es el nombre que sus contactos ven en los correos de alerta';

  @override
  String get failedToLoadProfile => 'Error al cargar el perfil';

  @override
  String get nameRequired => 'El nombre es obligatorio';
}
