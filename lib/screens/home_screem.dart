import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsServices>(context);
    // Aca no necesito que se redibuje
    final authServices = Provider.of<AuthServices>(context, listen: false);

    if (productService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        leading: IconButton(
          onPressed: () {
            authServices.logout();
            // Este Navigator es para que destruya la pantalla anterior
            Navigator.pushReplacementNamed(context, 'login');
          },
          icon: Icon(Icons.login_outlined),
        ),
        centerTitle: true,
      ),
      // El listview builder crea los widget cuando estan cerca de la pantalla
      // Es decir, no los crea a todos de una
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productService.selectedProduct =
                productService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productService.products[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        // Esto es para crear un nuevo producto
        onPressed: () {
          productService.selectedProduct = new Product(
            available: false,
            name: '',
            price: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
