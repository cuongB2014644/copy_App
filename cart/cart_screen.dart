import 'package:flutter/material.dart';
import 'package:myshop/ui/orders/order_manager.dart';
import 'package:provider/provider.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';
import 'package:google_fonts/google_fonts.dart';

//giỏ hàng
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in the cart',  
        style: GoogleFonts.pinyonScript(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
      ),
      body: Column(
        children: <Widget>[
          CartSummary(
            cart: cart,
            onOrderNowPressed: cart.totalAmount <= 0
                ? null
                : () {
                    context.read<OrdersManager>().addOrder(
                          cart.products,
                          cart.totalAmount,
                        );
                    cart.clearAllItems();
                  },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CartItemList(cart),
          )
        ],
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(this.cart, {super.key});
  final CartManager cart;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) =>
                CartItemCard(productId: entry.key, cartItem: entry.value),
          )
          .toList(),
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cart,
    this.onOrderNowPressed,
  });

  final CartManager cart;
  final void Function()? onOrderNowPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total',
              style: GoogleFonts.lora(
                fontSize: 20,
              ),
            ),
            // const Spacer(),
          Text(
            '\$${cart.totalAmount.toStringAsFixed(2)}',
             style: GoogleFonts.lora(
                fontSize: 20,
                color: Colors.purple,
              ),
          ),

            TextButton(
              onPressed: onOrderNowPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child:Text('ORDER NOW',
               style: GoogleFonts.lora(
                fontSize: 20,
              ),),
            )
          ],
        ),
      ),
    );
  }
}
