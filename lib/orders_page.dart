import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final List<List<Map<String, String>>> orders;

  OrdersPage({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'Belum ada pesanan.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                double total = 0;
                for (var item in order) {
                  String price = item['price']!.replaceAll(RegExp(r'[^\d]'), '');
                  total += int.parse(price);
                }

                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ExpansionTile(
                    title: Text('Order #${index + 1}'),
                    subtitle: Text('Total: Rp. ${total.toStringAsFixed(0)},00'),
                    children: order.map((item) {
                      return ListTile(
                        leading: Image.asset(
                          item['image']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['name']!),
                        subtitle: Text(item['price']!),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
