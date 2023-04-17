import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shop_drawer.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

import '../screens/cart_screen.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.map,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(
          'My Pizza',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.primary,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => CartBadge(
              color: Theme.of(context).colorScheme.secondary,
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
      drawer: const ShopDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: ProductsGrid(_showOnlyFavorites),
                  ),
      ),
    );
  }
}
