import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ecommerce/models/kategori_model.dart';
import 'package:project_ecommerce/utils/barang_storage.dart';
import 'package:project_ecommerce/utils/kategori_storage.dart';
import 'package:project_ecommerce/utils/file_helper.dart';
import 'package:project_ecommerce/models/barang_model.dart';
import 'dashboard_screen.dart';
import 'rekap_screen.dart';
import 'profil_screen.dart';

class TambahBarangScreen extends StatefulWidget {
  const TambahBarangScreen({super.key});

  @override
  State<TambahBarangScreen> createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  List<KategoriModel> kategoriList = [];
  int _currentIndex = 2;

  final namaController = TextEditingController();
  final hargaJualController = TextEditingController();
  final hargaBeliController = TextEditingController();
  final bahanBakuController = TextEditingController();
  final labaController = TextEditingController();

  String selectedKategori = "";
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  void loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() {});
  }

  void openDeleteDialog() async {
    final list = kategoriList;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Kategori"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await KategoriStorage.deleteKategori(item.name);
                      Navigator.pop(context);
                      loadKategori();
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future pickImage() async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1500,
      maxHeight: 1500,
      imageQuality: 85,
    );

    if (file == null) return;

    File imgFile = File(file.path);

    try {
      imgFile = await convertToJpeg(imgFile);
    } catch (_) {}

    setState(() {
      selectedImage = imgFile;
    });
  }

  void tambahBarang() async {
    if (selectedKategori.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori terlebih dahulu")),
      );
      return;
    }

    final item = BarangModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      nama: namaController.text,
      bahanBaku: bahanBakuController.text,
      hargaJual: int.tryParse(hargaJualController.text) ?? 0,
      hargaBeli: int.tryParse(hargaBeliController.text) ?? 0,
      laba: int.tryParse(labaController.text) ?? 0,
      kategori: selectedKategori,
      imagePath: selectedImage?.path,
    );

    await BarangStorage.addBarang(item);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Barang berhasil ditambahkan")),
    );

    namaController.clear();
    bahanBakuController.clear();
    hargaJualController.clear();
    hargaBeliController.clear();
    labaController.clear();

    setState(() {
      selectedKategori = "";
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tambah Barang",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child:
                    selectedImage == null
                        ? const Icon(Icons.image_outlined, size: 110)
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
              ),
            ),

            const SizedBox(height: 35),

            // =============== DROPDOWN KATEGORI ================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    kategoriList.isEmpty
                        ? "Buat Kategori Terlebih Dahulu"
                        : "Pilih Kategori",
                  ),
                  value: kategoriList.isEmpty || selectedKategori.isEmpty
                      ? null
                      : selectedKategori,
                  isExpanded: true,
                  items: kategoriList.isEmpty
                      ? null
                      : kategoriList.map((item) {
                          return DropdownMenuItem(
                            value: item.name,
                            child: Text(item.name),
                          );
                        }).toList(),
                  onChanged: kategoriList.isEmpty
                      ? null // ✅ DISABLE saat kosong
                      : (value) {
                          setState(() {
                            selectedKategori = value!;
                          });
                        },
                ),
              ),
            ),

            const SizedBox(height: 15),

            _inputField("Nama Barang", namaController),
            const SizedBox(height: 15),

            _inputField("Bahan Baku", bahanBakuController),
            const SizedBox(height: 15),

            _inputField("Harga Jual", hargaJualController, isNumber: true),
            const SizedBox(height: 15),

            _inputField("Harga Modal", hargaBeliController, isNumber: true),
            const SizedBox(height: 15),

            _inputField("Laba", labaController, isNumber: true),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF173B63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: tambahBarang,
                child: const Text(
                  "Tambah ke daftar barang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  BottomNavigationBar _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xFF173B63),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == _currentIndex) return;

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RekapScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilScreen()),
          );
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Rekapitulasi",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: "Tambah Barang",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
