// ignore_for_file: avoid_print
//quản lí đơn đã đặt
import 'package:flutter/material.dart';
import 'package:myshop/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../orders/order_manager.dart';
import 'order_item_card.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders', 
        style: GoogleFonts.pinyonScript(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),),
      ),
      drawer: const AppDrawer(),
      // body: Consumer<OrdersManager>(
      //   builder: (ctx, ordersManager, child) {
      //     return ListView.builder(
      //       itemCount: ordersManager.orderCount,
      //       itemBuilder: (ctx, i) => OrderItemCard(ordersManager.orders[i]),
      //     );
      //   },
      // ),
      body: FutureBuilder(
        future: context.read<OrdersManager>().fetchOrder(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<OrdersManager>().fetchOrder(),
            child: const OrderItemsList(),
          );
        },
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersManager>(
      builder: (ctx, ordersManager, child) {
        return ListView.builder(
          itemCount: ordersManager.orderCount,
          itemBuilder: (ctx, i) => OrderItemCard(ordersManager.orders[i]),
        );
      },
    );
  }
}
