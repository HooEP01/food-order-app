import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../providers/cart.dart';

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton(this.cart, {super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      height: 50.0,
      width: deviceSize.width,
      child: FittedBox(
        child: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
              ? null
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Order>(
                    context,
                    listen: false,
                  ).addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  widget.cart.clear();
                },
          label: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Checkout'),
          extendedPadding: EdgeInsets.symmetric(
            horizontal: (deviceSize.width / 2) - 60,
          ),
        ),
      ),
    );
  }
}
