import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './screens/admin/user_products_screen.dart';
import './screens/admin/edit_product_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/splash_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/order.dart';
import './providers/cart.dart';
import './providers/auth.dart';

import './ultilities/buildMaterialColor.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order('', '', []),
          update: (ctx, auth, previousOrders) => Order(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'SKYE FOOD ORDERING APP',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: buildMaterialColor(const Color(0xFFF45050)),
            )
                .copyWith(
                  secondary: buildMaterialColor(const Color(0xFF000000)),
                  // secondary: buildMaterialColor(const Color(0xFFFFDD83)),
                )
                .copyWith(
                  tertiary: buildMaterialColor(const Color(0xFF00235B)),
                ),
            fontFamily: 'Mulish',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headlineLarge: const TextStyle(
                    color: Color(0xFFF45050),
                    fontFamily: 'BigShouldersStencilText',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineMedium: const TextStyle(
                    color: Color(0xFFF45050),
                    fontFamily: 'BigShouldersStencilText',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineSmall: const TextStyle(
                    color: Color.fromRGBO(20, 5, 51, 1),
                    fontFamily: 'BigShouldersStencilText',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyLarge: const TextStyle(
                    color: Color.fromRGBO(20, 5, 51, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyMedium: const TextStyle(
                    color: Color.fromRGBO(34, 20, 61, 1),
                    fontSize: 16,
                  ),
                  bodySmall: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(20, 5, 51, 1),
                  ),
                  titleLarge: const TextStyle(
                    fontSize: 18,
                    // color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  titleMedium: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(20, 5, 51, 1),
                    fontWeight: FontWeight.bold,
                  ),
                  titleSmall: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(20, 5, 51, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      (authResultSnapshot.connectionState ==
                              ConnectionState.waiting)
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) =>
                const ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrderScreen.routeName: (ctx) => const OrderScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
