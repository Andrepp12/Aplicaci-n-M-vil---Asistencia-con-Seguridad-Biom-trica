import 'package:flutter/material.dart';
import 'package:unt_biometric_auth/src/constants/routes.dart';
import 'package:unt_biometric_auth/src/models/ui/drawer_class.dart';

List<DrawerOptionClass> drawerOptions = [
  DrawerOptionClass(
      icon: const Icon(Icons.home), name: 'Inicio', route: AppRoutes.homeRoute),
  DrawerOptionClass(
      icon: const Icon(Icons.verified_user),
      name: 'Registrar Asistencia',
      route: AppRoutes.marcarAsistenciaRoute),
];
