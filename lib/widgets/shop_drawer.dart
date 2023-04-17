import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/admin/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ShopDrawer extends StatelessWidget {
  const ShopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'SKPE',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_basket,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
