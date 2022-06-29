import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  // Esto es para mantener la referencia a este formulario en el fromKey
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Esto es una nueva propiedad para alojar el valor del producto seleccionado
  Product product;

  // Esto es un constructor y no necesitamos mas cuerpo por eso no tiene {}
  // Esto es para que cuando toquemos un producto nosotros recibamos una copia
  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    this.product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
