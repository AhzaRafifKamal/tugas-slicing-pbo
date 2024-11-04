import 'package:flutter/material.dart';
import 'cart_page.dart'; 
import 'orders_page.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), 
    );
  }
}

// Kelas HomePage dengan StatefulWidget agar bisa mengelola state
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// State dari HomePage
class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Semua'; // Kategori yang dipilih
  int _selectedIndex = 0; // Indeks dari BottomNavigationBar yang dipilih

  // List untuk menyimpan item yang dipilih ke keranjang
  List<Map<String, String>> cartItems = [];

  // List untuk menyimpan pesanan
  List<List<Map<String, String>>> orders = [];

  // Fungsi untuk menangani perubahan tab di BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) { // untuk ke halaman cart
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(
            cartItems: cartItems,
            onCheckout: _handleCheckout,
          ),
        ),
      );
    } else if (index == 2) { // untuk ke halaman order
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersPage(orders: orders),
        ),
      );
    }
  }

  // Fungsi untuk menangani checkout
  void _handleCheckout() {
    if (cartItems.isNotEmpty) {
      setState(() {
        // untuk menambahkan salinan pesanan di cart ke order
        orders.add(List.from(cartItems));
        // untuk mengosongkan pesanan di halaman cart setelah melakukan checkout
        cartItems.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout berhasil!')), // tanda notifikasi checkout berhasil
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Lebar layar

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {}, // Tombol menu
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {}, // Tombol profile
          ),
        ],
      ),
      body: Column(
        children: [
          // pilihan kategori di bagian atas (makanan,minuman)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('Semua', Icons.local_restaurant, selectedCategory == 'Semua'),
                _buildCategoryButton('Makanan', Icons.food_bank_sharp, selectedCategory == 'Makanan'),
                _buildCategoryButton('Minuman', Icons.local_cafe, selectedCategory == 'Minuman'),
              ],
            ),
          ),
          // untuk menampilkan daftar produk berdasarkan kategori yang ada
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (screenWidth / 2) / 250,
              children: _getFilteredProducts(),
            ),
          ),
        ],
      ),
      // untuk navigasi di bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  // untuk membuat tombol kategori
  Widget _buildCategoryButton(String text, IconData icon, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = text; // untuk mengubah kategori yang dipilih (warna)
            });
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 30,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // untuk memfilter produk berdasarkan kategori yang dipilih
  List<Widget> _getFilteredProducts() {
    List<Map<String, String>> allProducts = [
      {'name': 'Burger', 'price': 'Rp. 25.000', 'image': 'assets/Burger.jpeg', 'category': 'Makanan'},
      {'name': 'EsTeh', 'price': 'Rp. 5.000', 'image': 'assets/EsTeh.jpeg', 'category': 'Minuman'},
      {'name': 'Burgir', 'price': 'Rp. 30.000', 'image': 'assets/Burgir.jpeg', 'category': 'Makanan'},
      {'name': 'Air mineral', 'price': 'Rp. 3.000', 'image': 'assets/Air.jpeg', 'category': 'Minuman'},
      {'name': 'Kentang goreng', 'price': 'Rp. 15.000', 'image': 'assets/kentang_goreng.jpeg', 'category': 'Makanan'},
      {'name': 'kopi liong', 'price': 'Rp. 5.000', 'image': 'assets/liong.jpeg', 'category': 'Minuman'},
    ];

    // Memfilter produk berdasarkan kategori yang dipilih
    List<Map<String, String>> filteredProducts = selectedCategory == 'Semua'
        ? allProducts
        : allProducts.where((product) => product['category'] == selectedCategory).toList();

    // Mengembalikan widget kartu produk
    return filteredProducts.map((product) => _buildProductCard(
      product['name']!,
      product['price']!,
      product['image']!,
    )).toList();
  }

  // untuk membuat kartu produk
  Widget _buildProductCard(String name, String price, String image) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(price, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.green), // Tombol untuk tambah ke keranjang
              onPressed: () {
                setState(() {
                  // untuk menambahkan item ke keranjang
                  cartItems.add({'name': name, 'price': price, 'image': image});
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name telah ditambahkan ke keranjang.')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
