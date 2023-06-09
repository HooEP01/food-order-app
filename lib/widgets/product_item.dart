import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: product.id,
                    );
                  },
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  product.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Text(
                'RM ${product.price.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: -18,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        auth.token as String, auth.userId as String);
                  },
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added item to cart!'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
