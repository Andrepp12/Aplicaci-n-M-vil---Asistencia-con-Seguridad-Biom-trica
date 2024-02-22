import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unt_biometric_auth/src/models/docente.dart';
import 'package:unt_biometric_auth/src/providers/docente_provider.dart';
import 'package:unt_biometric_auth/src/services/auth/auth_service.dart';
import 'package:unt_biometric_auth/src/constants/colors.dart';
import 'package:unt_biometric_auth/src/constants/routes.dart';
import 'package:unt_biometric_auth/src/models/profile.dart';
import 'package:unt_biometric_auth/src/models/ui/drawer_class.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerComponent> {
  late Profile profile;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    profile = Profile.fromSupabase(_authService.getCurrentUser()!);
  }

  @override
  Widget build(BuildContext context) {
    final docenteProvider = context.read<DocenteModel>();

    return Drawer(
        child: ListView(
      children: [
        ProfileDisplay(profile: profile),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Inicio"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.homeRoute, (route) => route.isFirst);
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          enabled: docenteProvider.docente?.status == DocenteStatus.approved,
          title: const Text("Registrar Asistencia"),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context,
                AppRoutes.marcarAsistenciaRoute, (route) => route.isFirst);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Cerrar Sesión"),
          onTap: () async {
            await _authService.logOut();
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.loginRoute, (Route<dynamic> route) => false);
          },
        )
      ],
    ));
  }
}

class DraweOption extends StatelessWidget {
  final DrawerOptionClass option;

  const DraweOption({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currRoute = ModalRoute.of(context)?.settings.name ?? "";

    return ListTile(
      leading: option.icon,
      title: Text(option.name),
      tileColor: option.route == currRoute
          ? ColorsApp.primaryColor.withOpacity(0.2)
          : null,
      onTap: () {
        if (option.route == currRoute) {
          Navigator.pop(context);
          return;
        }

        if (option.route == AppRoutes.homeRoute) {
          Navigator.pushNamedAndRemoveUntil(
              context, option.route, (route) => false);

          return;
        }

        Navigator.pushNamedAndRemoveUntil(
            context, option.route, (route) => route.isFirst);
      },
    );
  }
}

class ProfileDisplay extends StatelessWidget {
  final Profile profile;

  const ProfileDisplay({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsApp.primaryColor,
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                profile.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: ColorsApp.primaryForegroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                profile.email,
                style: const TextStyle(
                  color: ColorsApp.primaryForegroundColor,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profile.avatarUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                )),
          )
        ],
      ),
    );
  }
}
