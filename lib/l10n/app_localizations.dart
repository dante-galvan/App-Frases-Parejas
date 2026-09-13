import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Frases para Parejas'**
  String get appTitle;

  /// No description provided for @inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicio;

  /// No description provided for @explorar.
  ///
  /// In es, this message translates to:
  /// **'Explorar'**
  String get explorar;

  /// No description provided for @favoritos.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritos;

  /// No description provided for @ajustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustes;

  /// No description provided for @bienvenido.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido!'**
  String get bienvenido;

  /// No description provided for @seleccionaTemas.
  ///
  /// In es, this message translates to:
  /// **'Selecciona los temas que más te interesen para personalizar tu experiencia.'**
  String get seleccionaTemas;

  /// No description provided for @comenzarDescubrir.
  ///
  /// In es, this message translates to:
  /// **'Comenzar a descubrir'**
  String get comenzarDescubrir;

  /// No description provided for @fraseDelDia.
  ///
  /// In es, this message translates to:
  /// **'FRASE DEL DÍA'**
  String get fraseDelDia;

  /// No description provided for @tocaParaVerMas.
  ///
  /// In es, this message translates to:
  /// **'Toca para ver más'**
  String get tocaParaVerMas;

  /// No description provided for @explorarPorCategoria.
  ///
  /// In es, this message translates to:
  /// **'Explorar por categoría'**
  String get explorarPorCategoria;

  /// No description provided for @frasesTrending.
  ///
  /// In es, this message translates to:
  /// **'Frases trending'**
  String get frasesTrending;

  /// No description provided for @recienLlegadas.
  ///
  /// In es, this message translates to:
  /// **'Recién llegadas'**
  String get recienLlegadas;

  /// No description provided for @todasLasFrases.
  ///
  /// In es, this message translates to:
  /// **'Todas las frases'**
  String get todasLasFrases;

  /// No description provided for @frases.
  ///
  /// In es, this message translates to:
  /// **'frases'**
  String get frases;

  /// No description provided for @apariencia.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get apariencia;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro'**
  String get modoOscuro;

  /// No description provided for @activado.
  ///
  /// In es, this message translates to:
  /// **'Activado'**
  String get activado;

  /// No description provided for @desactivado.
  ///
  /// In es, this message translates to:
  /// **'Desactivado'**
  String get desactivado;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @idiomaApp.
  ///
  /// In es, this message translates to:
  /// **'Idioma de la app'**
  String get idiomaApp;

  /// No description provided for @intereses.
  ///
  /// In es, this message translates to:
  /// **'Intereses'**
  String get intereses;

  /// No description provided for @temasInteres.
  ///
  /// In es, this message translates to:
  /// **'Temas de interés'**
  String get temasInteres;

  /// No description provided for @datos.
  ///
  /// In es, this message translates to:
  /// **'Datos'**
  String get datos;

  /// No description provided for @historialFrases.
  ///
  /// In es, this message translates to:
  /// **'Historial de frases vistas'**
  String get historialFrases;

  /// No description provided for @historialFrasesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Revisa las últimas frases'**
  String get historialFrasesSubtitle;

  /// No description provided for @reiniciarOnboarding.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar onboarding'**
  String get reiniciarOnboarding;

  /// No description provided for @reiniciarOnboardingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a ver la pantalla de inicio'**
  String get reiniciarOnboardingSubtitle;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión 2.0.0'**
  String get version;

  /// No description provided for @seleccionarIdioma.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar idioma'**
  String get seleccionarIdioma;

  /// No description provided for @editarIntereses.
  ///
  /// In es, this message translates to:
  /// **'Editar intereses'**
  String get editarIntereses;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @todas.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get todas;

  /// No description provided for @todosLosTonos.
  ///
  /// In es, this message translates to:
  /// **'Todos los tonos'**
  String get todosLosTonos;

  /// No description provided for @noHayFrases.
  ///
  /// In es, this message translates to:
  /// **'No hay frases para este filtro'**
  String get noHayFrases;

  /// No description provided for @favoritosCount.
  ///
  /// In es, this message translates to:
  /// **'Favoritos ({count})'**
  String favoritosCount(int count);

  /// No description provided for @coleccionesCount.
  ///
  /// In es, this message translates to:
  /// **'Colecciones ({count})'**
  String coleccionesCount(int count);

  /// No description provided for @sinFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes favoritos'**
  String get sinFavoritos;

  /// No description provided for @tocaCorazon.
  ///
  /// In es, this message translates to:
  /// **'Toca el corazón en cualquier frase para guardarla aquí'**
  String get tocaCorazon;

  /// No description provided for @sinColecciones.
  ///
  /// In es, this message translates to:
  /// **'Sin colecciones'**
  String get sinColecciones;

  /// No description provided for @creaColeccion.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera colección guardando frases desde cualquier tarjeta'**
  String get creaColeccion;

  /// No description provided for @colecciones.
  ///
  /// In es, this message translates to:
  /// **'Colecciones'**
  String get colecciones;

  /// No description provided for @agregar.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get agregar;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @frasesEnColeccion.
  ///
  /// In es, this message translates to:
  /// **'Frases en \"{name}\"'**
  String frasesEnColeccion(String name);

  /// No description provided for @nuevaColeccion.
  ///
  /// In es, this message translates to:
  /// **'Nueva colección'**
  String get nuevaColeccion;

  /// No description provided for @nombreColeccion.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la colección'**
  String get nombreColeccion;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @crear.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get crear;

  /// No description provided for @coleccionCreada.
  ///
  /// In es, this message translates to:
  /// **'Colección creada'**
  String get coleccionCreada;

  /// No description provided for @agregadaAColeccion.
  ///
  /// In es, this message translates to:
  /// **'Agregada a colección'**
  String get agregadaAColeccion;

  /// No description provided for @eliminadaDeColeccion.
  ///
  /// In es, this message translates to:
  /// **'Eliminada de colección'**
  String get eliminadaDeColeccion;

  /// No description provided for @masFrases.
  ///
  /// In es, this message translates to:
  /// **'Más frases'**
  String get masFrases;

  /// No description provided for @guardadaEnFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Guardada en favoritos'**
  String get guardadaEnFavoritos;

  /// No description provided for @eliminadaDeFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Eliminada de favoritos'**
  String get eliminadaDeFavoritos;

  /// No description provided for @generandoImagen.
  ///
  /// In es, this message translates to:
  /// **'Generando imagen...'**
  String get generandoImagen;

  /// No description provided for @guardadaEnGaleria.
  ///
  /// In es, this message translates to:
  /// **'Guardada en tu galería'**
  String get guardadaEnGaleria;

  /// No description provided for @noPudoGuardar.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar'**
  String get noPudoGuardar;

  /// No description provided for @agregarAColeccion.
  ///
  /// In es, this message translates to:
  /// **'Agregar a colección'**
  String get agregarAColeccion;

  /// No description provided for @historial.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get historial;

  /// No description provided for @historialCount.
  ///
  /// In es, this message translates to:
  /// **'Historial ({count})'**
  String historialCount(int count);

  /// No description provided for @borrarTodo.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo'**
  String get borrarTodo;

  /// No description provided for @sinHistorial.
  ///
  /// In es, this message translates to:
  /// **'Sin historial'**
  String get sinHistorial;

  /// No description provided for @frasesQueVeas.
  ///
  /// In es, this message translates to:
  /// **'Las frases que veas aparecerán aquí'**
  String get frasesQueVeas;

  /// No description provided for @bienvenidoMensaje.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido! Catálogo de frases para parejas listo'**
  String get bienvenidoMensaje;

  /// No description provided for @descubrePorTemas.
  ///
  /// In es, this message translates to:
  /// **'Descubre frases románticas para dedicar a tu pareja'**
  String get descubrePorTemas;

  /// No description provided for @frasesGuardadas.
  ///
  /// In es, this message translates to:
  /// **'{count} frases guardadas'**
  String frasesGuardadas(int count);

  /// No description provided for @preferenciasCentro.
  ///
  /// In es, this message translates to:
  /// **'Preferencias y centro de control'**
  String get preferenciasCentro;

  /// No description provided for @destacada.
  ///
  /// In es, this message translates to:
  /// **'DESTACADA'**
  String get destacada;

  /// No description provided for @trending.
  ///
  /// In es, this message translates to:
  /// **'TRENDING'**
  String get trending;

  /// No description provided for @nueva.
  ///
  /// In es, this message translates to:
  /// **'NUEVA'**
  String get nueva;

  /// No description provided for @confirmarEliminar.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar esta colección?'**
  String get confirmarEliminar;

  /// No description provided for @eliminarColeccionMensaje.
  ///
  /// In es, this message translates to:
  /// **'Las frases no se eliminarán de la aplicación ni de favoritos.'**
  String get eliminarColeccionMensaje;

  /// No description provided for @editarNombre.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre'**
  String get editarNombre;

  /// No description provided for @eliminarColeccion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar colección'**
  String get eliminarColeccion;

  /// No description provided for @compartir.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get compartir;

  /// No description provided for @descargar.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get descargar;

  /// No description provided for @compartirFrase.
  ///
  /// In es, this message translates to:
  /// **'Compartir frase'**
  String get compartirFrase;

  /// No description provided for @imagenGuardada.
  ///
  /// In es, this message translates to:
  /// **'Imagen guardada en tu galería'**
  String get imagenGuardada;

  /// No description provided for @errorPermiso.
  ///
  /// In es, this message translates to:
  /// **'Permiso de almacenamiento denegado'**
  String get errorPermiso;

  /// No description provided for @errorCargarImagen.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la imagen'**
  String get errorCargarImagen;

  /// No description provided for @frase.
  ///
  /// In es, this message translates to:
  /// **'frase'**
  String get frase;

  /// No description provided for @ver.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get ver;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @favorito.
  ///
  /// In es, this message translates to:
  /// **'Favorito'**
  String get favorito;

  /// No description provided for @preparandoParaCompartir.
  ///
  /// In es, this message translates to:
  /// **'Preparando para compartir...'**
  String get preparandoParaCompartir;

  /// No description provided for @coleccion.
  ///
  /// In es, this message translates to:
  /// **'Colección'**
  String get coleccion;

  /// No description provided for @splashTagline.
  ///
  /// In es, this message translates to:
  /// **'Frases que hablan por ti'**
  String get splashTagline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
