import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          loadProduct.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image.network(
                loadProduct.imageUrl,
                fit: BoxFit.cover,
                height: 300,
                width: deviceSize.width - 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              width: double.infinity,
              child: Text(
                'Description',
                textAlign: TextAlign.start,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: double.infinity,
              child: Text(
                loadProduct.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
                softWrap: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              width: double.infinity,
              child: Text(
                'Price',
                textAlign: TextAlign.start,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: double.infinity,
              child: Text(
                'RM ${loadProduct.price}',
                textAlign: TextAlign.start,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
