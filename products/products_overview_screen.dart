import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/cart/cart_screen.dart';
import 'package:myshop/ui/products/products_manager.dart';
import 'package:myshop/ui/products/top_right_badge.dart';
import 'package:myshop/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'products_grid.dart';
// import '../shared/app_drawer.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Van Cuong\'s flora',
          style: GoogleFonts.pinyonScript(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),
          ProductFilterMenu(
            onFilterSelected: (filter) {
              setState(() {
                _showOnlyFavorites.value = filter == FilterOptions.favorites;
              });
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/564x/57/f0/35/57f035718d21cd0a4256f78a1751d0f3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: snapshot.connectionState == ConnectionState.done
                ? ValueListenableBuilder<bool>(
                    valueListenable: _showOnlyFavorites,
                    builder: (context, onlyFavorites, child) {
                      return ProductsGrid(onlyFavorites);
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

@override
Widget buildResults(BuildContext context) {
  final productsManager = context.read<ProductManager>();
  final cartManager = context.read<CartManager>(); // Truy cập CartManager

  final searchResults = productsManager.items
      .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
      .toList();

   return ListView.builder(
    itemCount: searchResults.length,
    itemBuilder: (context, index) {
      final product = searchResults[index];
      return ListTile(
        title: Text(product.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${product.price}'),
            Text('Description: ${product.description}'),
          ],
        ),
        leading: Image.network(product.imageUrl),
        onTap: () {
          // Hiển thị một hộp thoại xác nhận trước khi thêm sản phẩm vào giỏ hàng
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add to Cart'),
              content: Text('Do you want to add this item to your cart?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng hộp thoại
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    // Thêm sản phẩm vào giỏ hàng
                    cartManager.addCart(product, 1);
                    // Hiển thị thông báo khi sản phẩm được thêm vào giỏ hàng
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: const Text('Item added to cart'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              // Xóa sản phẩm nếu người dùng undo
                              cartManager.removeItem(product.id!);
                            },
                          ),
                        ),
                      );
                    Navigator.of(context).pop(); // Đóng hộp thoại
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called when the search query changes.
    // You can show search suggestions here.
    return const SizedBox(); // Return an empty widget for now.
  }
}

class ProductFilterMenu extends StatelessWidget {
  const ProductFilterMenu({super.key, this.onFilterSelected});

  final void Function(FilterOptions selectedValue)? onFilterSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onFilterSelected,
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show all'),
        )
      ],
    );
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
// Truy xuất CartManager thông qua widget Consumer
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

