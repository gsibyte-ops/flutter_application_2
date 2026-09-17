import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();

  // Fungsi buat manggil popup Kalender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Batas tahun paling bawah
      lastDate: DateTime.now(),  // Batas tahun paling atas (hari ini)
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
      ),
      body: SingleChildScrollView( // Biar halamannya bisa di-scroll
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Nama
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Contoh: Gabriel Putra',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // 2. Username
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Contoh: gabriel_p',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Contoh: email@domain.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 4. No HP
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  hintText: 'Contoh: 081234567890',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 5. Gender (Opsi cuma 2)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 6. Tanggal Lahir (Pake Kalender)
              TextFormField(
                controller: _dobController,
                readOnly: true, // Dimatiin biar ga bisa diketik manual pake keyboard
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  hintText: 'Pilih Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _selectDate(context), // Manggil fungsi kalender pas diklik
              ),
              const SizedBox(height: 16),

              // 7. Alamat
              TextFormField(
                maxLines: 3, // Dikasih space lebih gede buat ngetik alamat
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  hintText: 'Contoh: Jl. Mastrip, Jember',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 8. Password (Ada tombol hide/unhide)
              TextFormField(
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden; // Toggle logic
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 9. Tombol Submit
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Nanti logika kirim data ke database/API ditaruh di sini
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}