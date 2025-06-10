import 'package:reusemart/client/user_client.dart';
import 'package:flutter/material.dart';
import 'package:reusemart/entity/kategori.dart';

class KategoriDrawer extends StatelessWidget {
  final Function(int idKategori) onKategoriSelected;

  const KategoriDrawer({
    super.key,
    required this.onKategoriSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<Kategori>>(
        future: UserClient.getAllKategoris(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final kategoris = snapshot.data!;
          final Map<int, Map<String, dynamic>> grouped = {};

          for (final kategori in kategoris) {
            final id = kategori.idKategori!;
            if (id % 10 == 0) {
              grouped[id] = {"utama": kategori, "sub": <Kategori>[]};
            } else {
              final mainId = (id ~/ 10) * 10;
              grouped.putIfAbsent(mainId, () => {"utama": null, "sub": <Kategori>[]});
              grouped[mainId]!["sub"].add(kategori);
            }
          }

          return ListView(
           
             children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "KATEGORI",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
               const Divider(),
              ...grouped.entries.map((entry) {
                final utama = entry.value["utama"] as Kategori?;
                final subs = entry.value["sub"] as List<Kategori>;

                return ExpansionTile(
                  title: Text(utama?.namaKategori ?? "Kategori Utama Tidak Ditemukan"),
                  children: subs.map((sub) {
                    return ListTile(
                      title: Text(sub.namaKategori ?? "Subkategori Tidak Ditemukan"),
                      onTap: () => onKategoriSelected(sub.idKategori!),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}