import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // No necesito que se redibuje asique le dejamos el listen en false para que no escuche ningun cambio
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authServices.readToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // Si no tiene data va a retornar al espere
          if (!snapshot.hasData) return Text('Espere');

          // Si no tenemos la data ejecutamos esto
          if (snapshot == '') {
            // Esto es para salvar un error que hay porque esta haciendo un tipo de redireccion y media construccion
            // Esta esperando que termine de construirse pero el widget tiene que terminar de construirse antes de poder hacer una navegacion
            // El microtask lo que hace es esprar hasta que termine de construirse el widget e inmediatamente despues ejecuta ese codigo
            // Muy util
            Future.microtask(() {
              // Usamos este navigator con estas configuraciones para poder salvar la transicion horrible que se ve
              // con el otro navigator mas abajo
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
              // Navigator.of(context).pushReplacementNamed('login');
            });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            });
          }

          return Container();
        },
      )),
    );
  }
}
