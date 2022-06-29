import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-b26fb-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  // Esto quiere decir que cuando se vaya a utilizar ya tenemos un valor
  late Product selectedProduct;

  // Ponemos esto para acoplarlo al auth services, es muy util porque sin esto cuando pongamos las regas en firebase nos va a tirar un error
  final storage = FlutterSecureStorage();

  // Importado de dart:io, es donde vamos a guardar la imagen seleccionada
  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsServices() {
    loadProducts();
  }
  // TODO: <List<Product>>
  Future<List<Product>> loadProducts() async {
    // Aca esta cargando asique va a mostrar la pantalla de cargando
    isLoading = true;
    notifyListeners();
    // Peticion al backend
    final url = Uri.https(
      _baseUrl,
      'product.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final resp = await http.get(url);

    // La resp esta como un string y hay que parciarlo, hay que decodificarlo
    final Map<String, dynamic> productMap = json.decode(resp.body);

    productMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    // Aca ya dejo de cargar asique se sale del cosito de cargando
    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // Es necesario crear
      await createProduct(product);
      // isSaving = false;
      // notifyListeners();
    } else {
      // Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
    return;
  }

  // Esto es para actualizar un producto
  Future<String> updateProduct(Product product) async {
    // Peticion al backend
    final url = Uri.https(
      _baseUrl,
      'product/${product.id}.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    // el put se usa para reemplazar informacion
    final resp = await http.put(url, body: product.toJson());
    // final decodedData = resp.body;

    // print(decodedData);

    // Actualizar el listado de productos
    // Esto me va a regresar el indice del producto cuyo id es el id que estoy recibiendo
    final index =
        this.products.indexWhere((element) => element.id == product.id);
    // Ahora cambia el producto por ese index para que se vea modificado el nombre en el Home
    this.products[index] = product;
    notifyListeners();

    return product.id!;
  }

  // Aca tenemos para crear un producto nuevo que no tiene id
  Future<String> createProduct(Product product) async {
    // Peticion al backend
    final url = Uri.https(
      _baseUrl,
      'product.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    // El post se usa para crear algo
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    // final decodedData = resp.body;
    // print(decodedData);
    // Modificamos el id
    product.id = decodedData['name'];

    // Agregamos el id a la lista de productos
    products.add(product);
    notifyListeners();
    return product.id!;
    // return '';
  }

  // Esta funcion es para cambiar la imagen de la galeria o de la camara del producto seleccionado
  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    // Esto es una medida de seguridad para asegurarnos de que tenemos una imagen
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    // Ese url lo sacamos del postman
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/nocolais/image/upload?upload_preset=a1rrsyxh');

    // Creamos la peticion
    final imageUploadRequest = http.MultipartRequest('POST', url);

    // Adjuntamos el file
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal guacho');
      print(resp.body);
      return null;
    }

    // Esto es para limpiar esta propiedad
    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
