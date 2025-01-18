import 'package:app_toplanti/home_page.dart';
import 'package:app_toplanti/meeting_update_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Tarih formatlama için
import 'package:firebase_auth/firebase_auth.dart';  // For Firebase Authentication

class MeetingDetailPage extends StatefulWidget {
  final String meetingId;
  final Map<String, dynamic> meeting;

  MeetingDetailPage({required this.meetingId, required this.meeting});

  @override
  _MeetingDetailPageState createState() => _MeetingDetailPageState();
}

class _MeetingDetailPageState extends State<MeetingDetailPage> {
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    // Get the current user's email
    currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toplantı Detayı"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('toplantilar')
            .doc(widget.meetingId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu."));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Toplantı bulunamadı."));
          }

          var meetingData = snapshot.data!.data() as Map<String, dynamic>;

          // Tarih ve saat formatlama
          String formattedDate = _formatDate(meetingData['tarih']);
          String formattedTime = _formatTime(meetingData['tarih']);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 19,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Toplantı Adı:", meetingData['toplantiAdi']),
                        SizedBox(height: 10),
                        _buildInfoRow("Kurucu:", meetingData['toplantiKurucu'] ?? ""),
                        SizedBox(height: 10),
                        _buildInfoRow("Kurucu Mail:", meetingData['kurucuMail'] ?? ""),
                        SizedBox(height: 10),
                        _buildInfoRow("Konum:", meetingData['toplantiKonumu'] ?? ""),
                        SizedBox(height: 10),
                        _buildInfoRow("Tarih:", formattedDate),
                        SizedBox(height: 5),
                        _buildInfoRow("Saat:", formattedTime),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Durum: ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label: Text(
                                meetingData['aktifMi'] ? "Aktif" : "Pasif",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: meetingData['aktifMi'] ? Colors.green : Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Toplantı Notları:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    meetingData['toplantiAciklamasi'] ?? "Toplantıya ait herhangi bir not bulunmamaktadır.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentUserEmail == meetingData['kurucuMail']) // Check if current user email matches creator's email
                      _buildActionButton(
                        context: context,
                        label: "Sil",
                        icon: Icons.delete,
                        color: Colors.redAccent,
                        onPressed: () {
                          openWindowDelete(context, 1);
                        },
                      ),
                    if (currentUserEmail == meetingData['kurucuMail']) // Check if current user email matches creator's email
                      _buildActionButton(
                        context: context,
                        label: "Güncelle",
                        icon: Icons.update,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MeetingUpdatePage(
                                    meetingId: widget.meetingId,
                                    meeting: meetingData
                                );
                              },
                            ),
                          ).then((_){
                            setState(() {});
                          });
                        },
                      ),
                    if (currentUserEmail != meetingData['kurucuMail']) // Kullanıcının yetkisi yoksa
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Bu toplantıyı düzenleme yetkiniz bulunmamaktadır.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Tarih formatlama
  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy').format(date); // İstediğiniz formatta
    }
    return "";
  }

  // Saat formatlama
  String _formatTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime time = timestamp.toDate();
      return DateFormat('HH:mm').format(time); // Saat formatı
    }
    return "";
  }

  Widget _buildInfoRow(String label, String? value) {
    return value != null && value.isNotEmpty
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    )
        : SizedBox(); // Boşsa, boş döndür
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
      ),
    );
  }

  Future<String?> openWindowDelete(BuildContext context, int index) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc = '';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                "Silme İşlemi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bu toplantıyı silmek istediğinizden emin misiniz?"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(sonuc = "İptal Edildi");
                    },
                    child: Text("Hayır", style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Firestore'dan toplantıyı silme işlemi
                      try {
                        await FirebaseFirestore.instance
                            .collection('toplantilar')
                            .doc(widget.meetingId)
                            .delete();

                        // Silme işlemi başarılı, geri dön
                       MaterialPageRoute pageRoute=MaterialPageRoute(
                           builder: (BuildContext context){
                             return HomePage();
                           });
                        Navigator.push(context, pageRoute);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Toplantı başarıyla silindi."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        // Hata durumunda geri dön
                        Navigator.of(context).pop(sonuc = "Silme işlemi başarısız.");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Silme işlemi başarısız."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text("Evet", style: TextStyle(color: Colors.red)),
                  ),

                ],
              )
            ],
          ),
        );
      },
    );
  }
}
