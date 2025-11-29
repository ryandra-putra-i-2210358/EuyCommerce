import 'package:flutter/material.dart';
// import 'success_payment_screen.dart';
import 'package:project_ecommerce/pages/loading_payment_screen.dart';
class PaymentMethodScreen extends StatelessWidget {
  final int totalHarga;

  const PaymentMethodScreen({super.key, required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    final metodeList = [
      {"nama": "BCA", "icon": Icons.credit_card},
      {"nama": "Mandiri", "icon": Icons.credit_card},
      {"nama": "Dana", "icon": Icons.account_balance_wallet},
      {"nama": "OVO", "icon": Icons.account_balance_wallet},
      {"nama": "Indomaret", "icon": Icons.store},
      {"nama": "Alfamart", "icon": Icons.store},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: const Text("Metode Pembayaran", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView.builder(
        itemCount: metodeList.length,
        itemBuilder: (context, index) {
          final metode = metodeList[index];

          return ListTile(
            leading: Icon(metode["icon"] as IconData, size: 30),
            title: Text(
              metode["nama"] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoadingPaymentScreen(
                    metode: metode["nama"] as String,
                    totalBayar: totalHarga,
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
