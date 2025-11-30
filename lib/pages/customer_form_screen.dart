import 'package:flutter/material.dart';
import 'invoice_screen.dart';

class CustomerFormScreen extends StatefulWidget {
  final int totalHarga;
  final List items;

  const CustomerFormScreen({
    super.key,
    required this.totalHarga,
    required this.items,
  });

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final nohpController = TextEditingController();
  final alamatController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: const Text("Data Customer", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              // NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              // NO HP
              TextFormField(
                controller: nohpController,
                decoration: const InputDecoration(labelText: "No. HP"),
                validator: (v) => v!.isEmpty ? "No HP wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              // ALAMAT
              TextFormField(
                controller: alamatController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Alamat Lengkap"),
                validator: (v) => v!.isEmpty ? "Alamat wajib diisi" : null,
              ),

              const SizedBox(height: 25),

              // BUTTON LANJUT
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF173B63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceScreen(
                            totalHarga: widget.totalHarga,
                            items: widget.items,
                            customerNama: namaController.text,
                            customerEmail: emailController.text,
                            customerNohp: nohpController.text,
                            customerAlamat: alamatController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Lanjut ke Invoice",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
