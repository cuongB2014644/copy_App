import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/user_products_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
         Container(
            height: 75, // Đặt chiều cao của container chứa hình ảnh và tiêu đề
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Ảnh làm nền
                Image.asset(
                  "lib/ui/auth/images/hinhnen.jpg",
                  fit: BoxFit.cover,
                ),
                // Widget Opacity để làm mờ ảnh nền
                Opacity(
                  opacity: 0.7, // Độ mờ, từ 0.0 (không mờ) đến 1.0 (hoàn toàn mờ)
                  child: Container(
                    color: const Color.fromARGB(255, 252, 249, 249), // Màu của lớp mờ
                  ),
                ),
                // Tiêu đề
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome to the world of flowers',
                    style: GoogleFonts.pinyonScript(
                      color: Color.fromARGB(255, 42, 106, 10),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text('Logout', style: GoogleFonts.lora(),),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: Text('Shop', style: GoogleFonts.lora(),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title:  Text('Orders', style: GoogleFonts.lora(),),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('Manage Products', style: GoogleFonts.lora(),),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
