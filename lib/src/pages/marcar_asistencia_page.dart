import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/src/components/drawer.dart';
import 'package:unt_biometric_auth/src/components/registro_card.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/constants/map.dart';
import 'package:unt_biometric_auth/src/dtos/create_registro_dto.dart';
import 'package:unt_biometric_auth/src/mocks/locations_mocks.dart';
import 'package:unt_biometric_auth/src/models/docente.dart';
import 'package:unt_biometric_auth/src/models/registro.dart';
import 'package:unt_biometric_auth/src/pages/biometric/face_rekognition_page.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';
import 'package:unt_biometric_auth/src/providers/registro_provider.dart';
import 'package:unt_biometric_auth/src/services/auth/local_auth_service.dart';
import 'package:unt_biometric_auth/src/services/map/location_service.dart';
import 'package:unt_biometric_auth/src/utils/location_utils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unt_biometric_auth/src/utils/widget_state.dart';

class MarcarAsistenciaPage extends StatefulWidget {
  const MarcarAsistenciaPage({super.key});

  @override
  State<MarcarAsistenciaPage> createState() => _MarcarAsistenciaPageState();
}

class _MarcarAsistenciaPageState extends State<MarcarAsistenciaPage> {
  late WidgetState _widgetState = WidgetState.NONE;

  final locationService = LocationService();
  final LatLng _center = centerUNT;
  late LatLng _userCurrenPosition = centerUNT;

  void _updateFunctionCallback(Position position) {
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    if (!mounted) return;
    setState(() {
      isInSelectectArea =
          LocationUtils.isPointInPolygon(latLngPosition, areaUNT.points);
      _userCurrenPosition = latLngPosition;
    });
  }

  // Google Maps
  late GoogleMapController mapController;
  bool isInSelectectArea = true;

  void _onMapCreated(
      GoogleMapController controller, RegistroProvider registroProvider) async {
    mapController = controller;

    LatLng untCenter = LocationUtils.getCenterOfPolygon(areaUNT.points);
    Position currPostition = await locationService.getCurrentPosition();

    LatLngBounds bounds = LocationUtils.getBoundFromTwoPoints(
        LatLng(currPostition.latitude - 0.001, currPostition.longitude - 0.001),
        LatLng(untCenter.latitude + 0.001, untCenter.longitude + 0.001));

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    setState(() {
      _userCurrenPosition =
          LatLng(currPostition.latitude, currPostition.longitude);
      _widgetState = WidgetState.LOADED;
    });
    registroProvider.setCreatingTerminoGeolocalizacion();
    await locationService.startPositionStream(_updateFunctionCallback);
  }

  @override
  void initState() {
    super.initState();
    final registroProvider = context.read<RegistroProvider>();
    registroProvider.initCreateRegistro();
  }

  @override
  void dispose() {
    locationService.stopPositionStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registroProvider = context.read<RegistroProvider>();
    // _widgetState = WidgetState.LOADING;
    return Scaffold(
        drawer: const DrawerComponent(),
        appBar: AppBar(
          title: const Text('Registro de asistencia'),
          backgroundColor: ColorsApp.primaryColor,
        ),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) {
                      _onMapCreated(controller, registroProvider);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    polygons: {
                      Polygon(
                          polygonId: const PolygonId("UNT"),
                          points: areaUNT.points,
                          fillColor: ColorsApp.primaryColor.withOpacity(0.2),
                          strokeColor: ColorsApp.primaryColor,
                          strokeWidth: 2)
                    },
                    markers: {
                      if (_widgetState != WidgetState.LOADING &&
                          _widgetState != WidgetState.NONE)
                        Marker(
                          markerId: const MarkerId("user"),
                          position: _userCurrenPosition,
                          infoWindow:
                              const InfoWindow(title: "Posición actual"),
                          //
                        )
                    },
                    gestureRecognizers: Set()
                      ..add(Factory<EagerGestureRecognizer>(
                          () => EagerGestureRecognizer())),
                  ),
                  // Loading
                  if (_widgetState == WidgetState.LOADING ||
                      _widgetState == WidgetState.NONE)
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: ColorsApp.primaryColor.withOpacity(0.2),
                        ),
                        child:
                            const Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
            MarcarAsistenciaActions(
                inside: isInSelectectArea, widgetState: _widgetState),
          ],
        ));
  }
}

class MarcarAsistenciaActions extends StatefulWidget {
  final bool inside;
  final WidgetState widgetState;
  const MarcarAsistenciaActions(
      {Key? key, required this.inside, this.widgetState = WidgetState.NONE})
      : super(key: key);

  @override
  _MarcarAsistenciaActionsState createState() =>
      _MarcarAsistenciaActionsState();
}

class _MarcarAsistenciaActionsState extends State<MarcarAsistenciaActions> {
  final _locationService = LocationService();
  final LocalAuthService _localAuthService = LocalAuthService();
  var isBiometricAvailable = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _localAuthService.hasBiometric().then((value) {
      setState(() {
        isBiometricAvailable = value;
      });
    });
  }

  Future<bool> doLocalAuth() async {
    final didAuthenticate = await _localAuthService.authenticate();
    if (didAuthenticate) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Autenticación Biométrica Local Exitosa",
        ),
        backgroundColor: Colors.green,
      ));
      return true;
    }
    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Autenticación Biométrica Local Fallida",
      ),
      backgroundColor: Colors.red,
    ));
    return false;
  }

  Future<bool> doRekogAuth(
      TipoRegistro tipo, RegistroProvider registroProvider) async {
    final pos = await _locationService.getCurrentPosition();

    if (!mounted) return false;

    final docente = context.read<DocenteModel>().docente;

    if (docente == null) return false;

    registroProvider.setCreatingRegistro(CreateRegistroDto(
        docenteId: docente.id,
        tipo: tipo,
        latitud: pos.latitude,
        longitud: pos.longitude));

    final value = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const FaceRekognitionPage()));

    if (value == 'success') {
      final res = await registroProvider.createRegistro();
      if (res) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Se registro su ${tipo.name}",
          ),
          backgroundColor: Colors.green,
        ));
      } else {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Ocurrio un error al registrar su ${tipo.name}",
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "No se registró su ${tipo.name}",
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    registroProvider.clearCreatingRegistro();
    return true;
  }

  bool doValidations(
    DocenteModel docenteModel,
    TipoRegistro tipo,
    RegistroProvider registroProvider,
  ) {
    if (docenteModel.docente?.status != DocenteStatus.approved) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error! El docente no se encuentra habilitado",
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    // if (!widget.inside) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //       "Error! No se encuentra en la universidad",
    //     ),
    //     backgroundColor: Colors.red,
    //   ));
    //   return false;
    // }
    if (tipo == TipoRegistro.entrada &&
        registroProvider.lastRegistro != null &&
        registroProvider.lastRegistro!.tipo == TipoRegistro.entrada) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error! Ya se registró su entrada",
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    if (tipo == TipoRegistro.salida && registroProvider.lastEntrada == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error! No se registró su entrada",
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    if (tipo == TipoRegistro.salida &&
        registroProvider.lastRegistro != null &&
        registroProvider.lastRegistro!.tipo == TipoRegistro.salida) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error! Ya se registró su salida",
        ),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return true;
  }

  void _marcarAsistencia(
    BuildContext context,
    TipoRegistro tipo,
  ) async {
    try {
      final registroProvider = context.read<RegistroProvider>();

      if (!doValidations(
          context.read<DocenteModel>(), tipo, registroProvider)) {
        return;
      }
      if (isBiometricAvailable) {
        registroProvider.setCreatingInicioBiometricoLocal();
        final localAuthSuccess = await doLocalAuth();
        registroProvider.setCreatingFinBiometricoLocal();
        if (!localAuthSuccess) return;
      }

      final rekogAuthSuccess = await doRekogAuth(tipo, registroProvider);
      if (!rekogAuthSuccess) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Ocurrio un error al registrar su ${tipo.name}",
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistroProvider>(
      builder: (context, value, child) {
        return Column(children: [
          if (widget.widgetState == WidgetState.LOADING ||
              widget.widgetState == WidgetState.NONE)
            Text(
              "Cargando...",
              style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                    color: Colors.grey,
                  ),
            ),
          if (widget.widgetState == WidgetState.LOADED)
            if (widget.inside)
              Text(
                "Se encuentra en la universidad",
                style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                      color: ColorsApp.primaryColor,
                    ),
              )
            else
              Text(
                "No se encuentra en la universidad",
                style: FlutterFlowTheme.of(context).bodyLarge.copyWith(
                      color: Colors.red,
                    ),
              ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: Text(
                  DateFormat.MMMMEEEEd('es_PE').format(DateTime.now()),
                  style: FlutterFlowTheme.of(context).headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    InkWell(
                      onTap: () async {
                        _marcarAsistencia(context, TipoRegistro.entrada);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        height: 160,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 12, 12, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 12),
                                child: Text(
                                  'Entrada',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                ),
                              ),
                              if (value.lastEntrada != null)
                                Text(
                                  DateFormat('hh:mm a')
                                      .format(value.lastEntrada!.createdAt),
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                ),
                              const Icon(
                                Icons.login,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _marcarAsistencia(context, TipoRegistro.salida);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDA1E89),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 12, 12, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 12),
                                child: Text(
                                  'Salida',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                ),
                              ),
                              if (value.lastSalida != null)
                                Text(
                                  DateFormat('hh:mm a')
                                      .format(value.lastSalida!.createdAt),
                                  style: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                ),
                              const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: Text(
                    'Eventos de tiempo: Hoy',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).labelLarge,
                  )),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 80),
                child: Column(
                  children: [
                    ...value.registrosToday.map((e) {
                      return RegistroCard(registro: e);
                    }).toList()
                  ],
                ),
              )
            ],
          ),
        ]);
      },
    );
  }
}
