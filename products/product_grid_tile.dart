// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/products/products_manager.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'products_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'products_manager.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    Key? key,
    this.onAddToCartPressed, // để sử dụng thêm sp trong tìm kiếm
  }) : super(key: key);

  final Product product;
  final VoidCallback? onAddToCartPressed;// để sử dụng thêm sp trong tìm kiếm

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: GridTile(
          header: ProductGridHeader(
            product: product,
            onFavoritePressed: () {
              // Nghịch đảo giá trị isFavorite của product
              context.read<ProductManager>().toggleFavoriteStatus(product);
            },
          ),
          footer: ProductGridFooter(
            product: product,
            onAddToCartPressed: () {
              // Đọc ra CartManager dùng context.read
              final cart = context.read<CartManager>();
              cart.addCart(product, 1);
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
                        // Xóa product nếu undo
                        cart.removeItem(product.id!);
                      },
                    ),
                  ),
                );
            },
          ),
          child: GestureDetector(
            //bắt sự kiện (khi hình ảnh được nhấn vào).
            onTap: () {
              //Chuyển đến trang ProductDetailScreen
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Container(),
          )),
    );
  }
}

class ProductGridHeader extends StatelessWidget {
  const ProductGridHeader({
    super.key,
    required this.product,
    this.onFavoritePressed,
  });

  final Product product;
  final void Function()?
      onFavoritePressed; //biến onFavoritePressed có thể chứa một giá trị hàm hoặc có thể là null

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: SizedBox(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      product.imageUrl,
                      height: 130.0,
                      width: 164.0,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ]))),
        Positioned(
          top: 0,
          right: 8,
          child: ValueListenableBuilder<bool>(
            valueListenable: product.isFavoriteListenable,
            builder: (ctx, isFavorite, child) {
              return IconButton(
                //leading: một thành phần hiển thị ở phía trước (bên trái) của thanh
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: onFavoritePressed,
              );
            },
          ),
        ),
      ],
    );
  }
}

//footer bao gồm: icon_heart, title, icon_cart
// class ProductGridFooter extends StatelessWidget {
//   const ProductGridFooter({
//     super.key,
//     required this.product,
//     this.onAddToCartPressed,
//   });

//   final Product product;
//   final void Function()? onAddToCartPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Text(product.title,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           softWrap: false,
//           style: const TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
//       Text('\$${product.price}',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           softWrap: false,
//           style:
//               const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//       SizedBox(
//         width: 100,
//         height: 28,
//         child: TextButton(
//             style: ButtonStyle(
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               )),
//               padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(2)),
//               backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
//               foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//             ),
//             onPressed: onAddToCartPressed,
//             child: const Text(
//               "Add to cart",
//               style: TextStyle(color: Colors.white, fontSize: 15),
//             )),
//       ),
//     ]);
//   }
// }

class ProductGridFooter extends StatelessWidget {
  const ProductGridFooter({
    Key? key,
    required this.product,
    this.onAddToCartPressed,// để sử dụng thêm sp trong tìm kiếm
  }) : super(key: key);

  final Product product;
  final VoidCallback? onAddToCartPressed; // Thêm hàm callback vào footer

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          '\$${product.price}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 100,
          height: 28,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(2),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: onAddToCartPressed,
            child: Text(
              "Add to cart",
              style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
