// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/cart/cart_screen.dart';
//import 'package:myshop/ui/products/product_grid_tile.dart';
// import 'package:myshop/ui/products/products_overview_screen.dart';
import 'package:myshop/ui/products/top_right_badge.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:myshop/ui/products/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/cart/cart_manager.dart';
import 'package:myshop/ui/products/products_manager.dart'; // Import ProductManager


import '../../models/product.dart';


class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final counterItem = Provider.of<CounterItem>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
            counterItem.setCounter(1);
          },
          icon: const Icon(Icons.home),
        ),
        actions: <Widget>[
          DetailScreenShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          
        ],
        title: Center(
          child: Text(
            "Detail product",
            style: GoogleFonts.pinyonScript(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        //có thể cuộn nếu nội dung vượt quá màn hình

        child: Column(
          children: <Widget>[
            //ẢNH SP + HEART_BUTTON + BACK_BUTTON
              Stack(children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ClipRRect(
                    child: Image.network(product.imageUrl, fit: BoxFit.cover)
                  ),
                ),
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: IconButton(
                    icon: ValueListenableBuilder<bool>(
                      valueListenable: product.isFavoriteListenable,
                      builder: (ctx, isFavorite, child) {
                        return Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red, // Thay đổi màu sắc tùy thuộc vào trạng thái yêu thích
                          size: 30,
                        );
                      },
                    ),
                    onPressed: () {
                      // Thực hiện logic khi nhấn vào nút yêu thích
                      context.read<ProductManager>().toggleFavoriteStatus(product);
                    },
                  ),
                ),
              ]),


            const SizedBox(
                height: 10), //tạo khoảng trắng cách nhau giữa các column
            //TÊN SP
            Center(
                child: Text(
              product.title,
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            )),
            const SizedBox(height: 5),
            //GIÁ SP
            Text(
              '\$${product.price}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 118, 118, 118), fontSize: 20),
            ),

            const SizedBox(height: 10),
            //SỐ LƯỢNG SP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black54,
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: counterItem._decreaseCounter,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${counterItem.getCounter()}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: counterItem._increaseCounter,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero, // and this
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            //ADD TO CART BUTTON
            const SizedBox(height: 10),
            TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.purple),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  // Đọc ra CartManager dùng context.read
                  final cart = context.read<CartManager>();

                  cart.addCart(product, counterItem.getCounter());

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Item added to cart',
                        ),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            //Xóa product nếu undo
                            cart.removeItem(product.id!);
                          },
                        ),
                      ),
                    );
                },
                child: Text(
                  "Add to cart",
                  style: GoogleFonts.lora(color: Colors.white, fontSize: 20,)
                )),

            const SizedBox(height: 20),
            //MÔ TẢ SP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                // style: Theme.of(context).textTheme.titleLarge,
                style: GoogleFonts.lora(fontSize: 20,)
              ),
            )
          ],
        ),
      ),
    );
  }
}
//thêm để hiển thị số lượng sản phẩm
class DetailScreenShoppingCartButton extends StatelessWidget {
  const DetailScreenShoppingCartButton({Key? key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}

class CounterItem with ChangeNotifier {
  int _counter = 1;

  getCounter() => _counter;

  setCounter(int counter) => _counter = counter;

  void _increaseCounter() {
    _counter++;
    notifyListeners();
  }

  void _decreaseCounter() {
    if (_counter >= 2) {
      _counter--;
      notifyListeners();
    }
  }
}
