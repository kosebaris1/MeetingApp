import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeetingAddPage extends StatefulWidget {
  @override
  _MeetingAddPageState createState() => _MeetingAddPageState();
}

class _MeetingAddPageState extends State<MeetingAddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController toplantiAciklamasiController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isOnline = false;
  bool isFaceToFace = false;

  Future<void> _saveMeetingToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı oturumu açık değil!")),
      );
      return;
    }

    // Kullanıcı bilgilerini Firestore'dan al
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .get();

    final String userName = userDoc['userName'] ?? 'Bilinmiyor';
    final String firmaKodu = userDoc['firma'] ?? 'Bilinmiyor';
    final String kurucuMail=userDoc['mail'] ?? 'Bilinmiyor';

    final meetingData = {
      'toplantiAdi': titleController.text,
      'toplantiKonumu': isOnline
          ? 'Online'
          : (locationController.text.isNotEmpty
          ? locationController.text
          : null),
      'toplantiAciklamasi': toplantiAciklamasiController.text,
      'toplantiKurucu': userName,
      'alanKodu': firmaKodu,
      'kurucuMail':kurucuMail,
      'aktifMi':true,
      'tarih': selectedDate != null
          ? Timestamp.fromDate(DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      ))
          : null, // Tarih ve saat birleşimiyle Timestamp oluşturuluyor
    };


    if (meetingData['toplantiKonumu'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen toplantı konumunu giriniz!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('toplantilar').add(meetingData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("${titleController.text} adlı toplantı eklendi."),
         backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxlines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          maxLines: maxlines,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toplantı Ekle"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Toplantı Adı"),
              _buildTextField(
                controller: titleController,
                hintText: "Toplantı adını giriniz",
                maxlines: 1,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Tarih Seç"),
                        _buildDateSelector(),
                        const SizedBox(height: 10),
                        _buildSectionTitle("Saat Seç"),
                        _buildTimeSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Toplantı Açıklaması"),
                        _buildTextField(
                          controller: toplantiAciklamasiController,
                          hintText:
                          "Toplantı için notlarınızı buraya yazabilirsiniz...",
                          maxlines: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildSectionTitle("Toplantı Türü"),
              Row(
                children: [
                  Checkbox(
                    value: isOnline,
                    onChanged: (bool? value) {
                      setState(() {
                        isOnline = value ?? false;
                        if (isOnline) {
                          isFaceToFace = false;
                          locationController.clear();
                        }
                      });
                    },
                  ),
                  const Text("Online"),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: isFaceToFace,
                    onChanged: (bool? value) {
                      setState(() {
                        isFaceToFace = value ?? false;
                        if (isFaceToFace) {
                          isOnline = false;
                        }
                      });
                    },
                  ),
                  const Text("Yüzyüze"),
                ],
              ),
              const SizedBox(height: 16),
              if (isFaceToFace) _buildSectionTitle("Konum Bilgisi"),
              if (isFaceToFace)
                _buildTextField(
                  controller: locationController,
                  hintText: "Konum bilgisini giriniz",
                  maxlines: 1,
                ),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : "Tarih seçin",
          style: TextStyle(
            fontSize: 16,
            color: selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          selectedTime != null
              ? "${selectedTime!.hour}:${selectedTime!.minute}"
              : "Saat seçin",
          style: TextStyle(
            fontSize: 16,
            color: selectedTime != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "İptal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (titleController.text.isEmpty ||
                selectedDate == null ||
                selectedTime == null ||
                (!isOnline && !isFaceToFace) ||
                toplantiAciklamasiController.text.isEmpty ||
                (isFaceToFace && locationController.text.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
              );
            } else {
              _saveMeetingToFirestore();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.add_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Ekle",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
