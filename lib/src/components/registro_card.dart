import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unt_biometric_auth/src/constants/flutter_flow/flutter_flow_theme.dart';
import 'package:unt_biometric_auth/src/models/registro.dart';

class RegistroCard extends StatefulWidget {
  final Registro registro;
  const RegistroCard({super.key, required this.registro});

  @override
  _RegistroCardState createState() => _RegistroCardState();
}

class _RegistroCardState extends State<RegistroCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 570,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primaryBackground,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('hh:mm:ss a')
                            .format(widget.registro.createdAt),
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                      child: Icon(
                        Icons.login,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24,
                      ),
                    ),
                    Text(
                      widget.registro.tipo.name,
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
