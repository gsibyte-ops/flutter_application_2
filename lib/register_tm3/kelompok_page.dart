import 'package:flutter/material.dart';

class KelompokPage extends StatelessWidget {
  const KelompokPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Kelompok', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group, size: 60, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  const Text(
                    'Kelompok 4\n"Seadanya"',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  const Text(
                    'Daftar Anggota:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  
                  // List Anggota Kelompok
                  buildMemberRow('1. Satrio Wisnu Hidayanto', 'E41251367'),
                  buildMemberRow('2. Fachrimada Syafril Albariq', 'E41251199'),
                  buildMemberRow('3. Febri Dwi Hardiyono', 'E41251208'),
                  buildMemberRow('4. Muhammad Nanda Krisna M.', 'E41251310'),
                  buildMemberRow('5. Anggie Oktavia Nur R. M.', 'E41251470'),
                  buildMemberRow('6. Gabriel Putra Syahbani H.', 'E41251254'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi bantuan biar kode rapi (Nama di kiri, NIM di kanan)
  Widget buildMemberRow(String nama, String nim) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(nim, textAlign: TextAlign.right, style: const TextStyle(fontSize: 15, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}