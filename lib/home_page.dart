import 'package:app_toplanti/meeting_detail_page.dart';
import 'package:app_toplanti/meeting_add_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer.dart';

Future<void> updatePastMeetingsStatus() async {
  final meetingsRef = FirebaseFirestore.instance.collection('toplantilar');
  DateTime newTime = DateTime.now().add(Duration(hours: 3));

  final snapshot = await meetingsRef.get();
  for (var doc in snapshot.docs) {
    Timestamp timestamp = doc['tarih'];
    DateTime meetingDate = timestamp.toDate();

    if (meetingDate.isBefore(newTime)) {
      await meetingsRef.doc(doc.id).update({'aktifMi': false});
      print("Toplantı ${doc['toplantiAdi']} güncellendi.");
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Center(child: Text("Kullanıcı girişi yapılmamış."));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser.uid)
          .get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Center(child: Text("Kullanıcı bilgileri bulunamadı."));
        }

        String userFirmaKodu = userSnapshot.data!['firma'] ?? '';
        String userName = userSnapshot.data!['userName'] ?? '';

        if (userFirmaKodu.isEmpty) {
          return Center(child: Text("Firma kodu eksik. Lütfen firma kodunuzu girin."));
        }

        updatePastMeetingsStatus();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Toplantılarım",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false
            ,
            backgroundColor: Colors.deepPurpleAccent,
            actions: [
              IconButton(
                icon: Icon(Icons.date_range_rounded),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chip(
                  label: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('toplantilar')
                        .where('alanKodu', isEqualTo: userFirmaKodu)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Yükleniyor...",
                          style: const TextStyle(color: Colors.white),
                        );
                      }
                      final meetingsCount = snapshot.data?.docs.length ?? 0;
                      return Text(
                        "$meetingsCount Toplantı",
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          drawer: CustomDrawer(
            userName: userName,
            userEmail: currentUser.email ?? "example@example.com",
            profileImage: "assets/user_profile.jpg",
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('toplantilar')
                .where('alanKodu', isEqualTo: userFirmaKodu)
                .orderBy('tarih', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Toplantı bulunamadı."));
              }

              final allMeetings = snapshot.data!.docs.map((doc) {
                return {
                  'title': doc['toplantiAdi'],
                  'kurucuMail': doc['toplantiKurucu'],
                  'konum': doc['toplantiKonumu'],
                  'date': doc['tarih'],
                  'status': doc['aktifMi'],
                  'id': doc.id,
                };
              }).toList();

              final filteredMeetings = _selectedDate != null
                  ? allMeetings.where((meeting) {
                DateTime meetingDate = (meeting['date'] as Timestamp).toDate();
                return meetingDate.year == _selectedDate!.year &&
                    meetingDate.month == _selectedDate!.month &&
                    meetingDate.day == _selectedDate!.day;
              }).toList()
                  : allMeetings;

              if (filteredMeetings.isEmpty) {
                return Center(child: Text("Seçilen tarihte toplantı bulunamadı."));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: filteredMeetings.length,
                  itemBuilder: (context, index) {
                    final meeting = filteredMeetings[index];
                    DateTime dateTime = (meeting['date'] as Timestamp).toDate();
                    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                    String formattedTime = DateFormat('HH:mm').format(dateTime);

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                          backgroundColor: meeting['status'] == true
                              ? Colors.green
                              : Colors.grey,
                          child: Icon(
                            meeting['status'] == false
                                ? Icons.event_available
                                : Icons.event_busy,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          meeting['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: meeting['status'] == true
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        subtitle: Text("Tarih: $formattedDate\nSaat: $formattedTime"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetingDetailPage(
                                meetingId: meeting['id'],
                                meeting: meeting,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MeetingAddPage()),
              );
            },
            label: const Text("Ekle"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.deepPurple,
          ),
        );
      },
    );
  }
}
