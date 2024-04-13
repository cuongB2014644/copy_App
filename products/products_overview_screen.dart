import 'package:flutter/material.dart';
// import 'package:myshop/models/product.dart';
import '../shared/app_drawer.dart';
import 'package:provider/provider.dart';
import '../../ui/products/edit_product_screen.dart';

import '../../ui/products/user_product_list_tile.dart';
import '../products/products_manager.dart';
import 'package:google_fonts/google_fonts.dart';
//trang thêm sửa xóa products
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products',
         style: GoogleFonts.pinyonScript(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
        
        ),
        actions: <Widget>[
          AddUserProductButton(
            onPressed: () {
              // Chuyển đến trang EditProductScreen
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
          ),
        ],
        
      ),
      // Thêm Drawer
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: context.read<ProductManager>().fetchUserProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProductManager>().fetchUserProducts(),
            child: const UserProductList(),
          );
        },
      ),
    );
  }
}

class UserProductList extends StatelessWidget {
  const UserProductList({super.key});

  @override
  Widget build(BuildContext context) {


    // Dùng Consumer để truy xuất và lắng nghe báo hiệu
    // thay đổi trạng thái từ ProductsManager
    return Consumer<ProductManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductListTile(
                productsManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}

class AddUserProductButton extends StatelessWidget {
  const AddUserProductButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
    );
  }
}
