import 'package:flutter/material.dart';
import 'dart:io';

class ProductImage extends StatelessWidget {
  final String? url;

  const ProductImage({
    Key? key,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          decoration: _buildBoxDecoration(),
          width: double.infinity,
          height: 450,
          // Envolvemos todo en un Opacity para modificar la opacidad y que se vea el color de fondo
          // Asi se puede ver la flechita
          child: Opacity(
            opacity: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url),
            ),
          ),
        ));
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          // Hay un color de fondo en la imagen para que se vean las flechitas
          color: Colors.black,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ]);

  Widget getImage(String? picture) {
    // Por si la imagen no tiene nada
    if (picture == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    // Por si es una imagen de internet
    if (picture.startsWith('http'))
      return FadeInImage(
        image: NetworkImage(url!),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    // Por si es una imagen del dispositivo
    return Image.file(
      // Importar de dart:io
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
