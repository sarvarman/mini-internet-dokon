import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Namuna mahsulotlar ro'yxati
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Smartfon Pro',
      price: 599.0,
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
      description: 'Yuqori sifatli kamera va kuchli protsessorga ega zamonaviy smartfon.',
    ),
    Product(
      id: 2,
      name: 'Simsiz Naushnik',
      price: 99.0,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
      description: 'Qulay, shovqinni bekor qiluvchi va uzoq zaryad saqlaydigan naushnik.',
    ),
    Product(
      id: 3,
      name: 'Aqlli Soat',
      price: 150.0,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
      description: 'Sogligingizni kuzatib boruvchi va qo\'ngiroqlarni qabul qiluvchi soat.',
    ),
    Product(
      id: 4,
      name: 'Noutbuk Slim',
      price: 1200.0,
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853',
      description: 'Ish va o\'qish uchun yengil hamda tezkor noutbuk.',
    ),
  ];

  // Savatchaga qo'shilgan mahsulotlar ro'yxati
  final List<Product> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Internet Do\'kon'),
        centerTitle: true,
        actions: [
          // Savatcha tugmasi va sonini ko'rsatish
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 28),
                onPressed: () {
                  // Savatcha sahifasiga o'tish yoki ma'lumot chiqarish
                  _showCartDialog(context);
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  // Mahsulot tafsilotiga o'tish
                  final addedProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                  // Agar tafsilot sahifasidan savatchaga qo'shish bosilsa
                  if (addedProduct != null && addedProduct is Product) {
                    setState(() {
                      cart.add(addedProduct);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${addedProduct.name} savatchaga qo\'shildi!')),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Savatchadagi mahsulotlarni ko'rsatish uchun oyna (Dialog)
  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sizning savatchangiz'),
          content: SizedBox(
            width: double.maxFinite,
            child: cart.isEmpty
                ? const Text('Savatcha hozircha bo\'sh.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(cart[index].imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                        title: Text(cart[index].name),
                        subtitle: Text('\$${cart[index].price}'),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  }
}