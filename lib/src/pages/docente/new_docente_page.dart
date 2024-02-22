import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/components/button.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/dtos/create_docente_dto.dart';
import 'package:unt_biometric_auth/src/models/profile.dart';
import 'package:unt_biometric_auth/src/services/auth/auth_service.dart';
import 'package:unt_biometric_auth/src/services/docente_service.dart';
import 'package:unt_biometric_auth/src/services/escuela_service.dart';
import 'package:unt_biometric_auth/src/utils/name_util.dart';

class NewDocentePage extends StatefulWidget {
  const NewDocentePage({Key? key}) : super(key: key);

  @override
  _NewDocentePageState createState() => _NewDocentePageState();
}

class _NewDocentePageState extends State<NewDocentePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  final EscuelaService _escuelaService = EscuelaService();
  final DocenteService _docenteService = DocenteService();
  final List<Map<String, String>> _escuelas = [
    {
      'value': '',
      'label': 'Seleccione una escuela',
    }
  ];

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _escuelaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  String _selectedEscuelaId = '';
  String _correo = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    final profile = Profile.fromSupabase(_authService.getCurrentUser()!);
    final nameAndLastName = getNameAndLastName(profile.name);
    _nombresController.text = nameAndLastName.name;
    _apellidosController.text = nameAndLastName.lastName;
    _correo = profile.email;
    _avatarUrl = profile.avatarUrl;

    _fillEscuelasOptions();
  }

  Future<void> _fillEscuelasOptions() async {
    final escuelas = await _escuelaService.getEscuelas();
    setState(() {
      _escuelas.addAll(escuelas.map((e) => {'value': e.id, 'label': e.nombre}));
    });
  }

  void handleSubmit() async {
    try {
      // validaciones
      if (_nombresController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingrese su nombre'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_apellidosController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingrese sus apellidos'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_escuelaController.text.isEmpty || _selectedEscuelaId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor seleccione su escuela'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_telefonoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingrese su teléfono'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_telefonoController.text.length < 9 ||
          _telefonoController.text.length > 9) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingrese un teléfono válido'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // enviar datos
      final res = await _docenteService.createDocente(CreateDocenteDto(
          nombres: _nombresController.text,
          apellidos: _apellidosController.text,
          correo: _correo,
          escuelaId: _selectedEscuelaId,
          avatarUrl: _avatarUrl,
          telefono: _telefonoController.text));
      if (res) {
        if (!mounted) return;
        Navigator.popAndPushNamed(context, "/home");

        return;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error al guardar los datos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al guardar los datos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Stack(children: [
              SafeArea(
                  top: true,
                  child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Container(
                          width: 440,
                          decoration: const BoxDecoration(),
                          child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 14, 0, 14),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24, 0, 0, 0),
                                            child: Text(
                                              'Completa tu perfil',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: ColorsApp.primaryColor,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {},
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            2, 2, 2, 2),
                                                    child: Container(
                                                      width: 90,
                                                      height: 90,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.network(
                                                        _avatarUrl,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 0, 20, 16),
                                          child: TextFormField(
                                            controller: _nombresController,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Nombres',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 0, 24),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 0, 20, 16),
                                          child: TextFormField(
                                            controller: _apellidosController,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Apellidos',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 0, 24),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(20, 0, 20, 16),
                                            child: DropdownMenu<String>(
                                                controller: _escuelaController,
                                                onSelected: (String? newValue) {
                                                  setState(() {
                                                    _selectedEscuelaId =
                                                        newValue!;
                                                  });
                                                },
                                                enableSearch: false,
                                                enableFilter: false,
                                                requestFocusOnTap: false,
                                                width: 370,
                                                label: Text(
                                                  'Escuela',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium,
                                                ),
                                                inputDecorationTheme:
                                                    const InputDecorationTheme(
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              20, 24, 0, 24),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .auto,
                                                  filled: true,
                                                  fillColor: ColorsApp
                                                      .primaryForegroundColor,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: ColorsApp
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: ColorsApp
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                ),
                                                menuStyle: MenuStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll<
                                                          Color>(FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground),
                                                  elevation:
                                                      const MaterialStatePropertyAll<
                                                          double>(0),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  surfaceTintColor:
                                                      MaterialStateColor
                                                          .resolveWith((states) =>
                                                              ColorsApp
                                                                  .primaryColor),
                                                ),
                                                initialSelection: _escuelas
                                                    .first['value']!,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                dropdownMenuEntries: _escuelas
                                                    .map((e) =>
                                                        DropdownMenuEntry<
                                                                String>(
                                                            value: e['value'] ??
                                                                '',
                                                            label: e['label'] ??
                                                                ''))
                                                    .toList())),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 0, 20, 16),
                                          child: TextFormField(
                                            controller: _telefonoController,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Teléfono',
                                              labelStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              filled: true,
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 0, 24),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.00, 0.05),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 24, 0, 0),
                                            child: Button(
                                              onPressed: handleSubmit,
                                              text: 'Guardar',
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ])))))),
            ])));
  }
}
