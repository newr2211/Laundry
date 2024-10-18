import 'package:flutter/material.dart';
import 'package:myproject/widgets/custom_bottom_navbar.dart';

class QueueNotificationPage extends StatefulWidget {
  const QueueNotificationPage({Key? key}) : super(key: key);

  @override
  _QueueNotificationPageState createState() => _QueueNotificationPageState();
}

class _QueueNotificationPageState extends State<QueueNotificationPage> {
  int _selectedIndex = 2;
  
  // ตัวแปรสำหรับ Checkbox
  bool washClothes = false;
  bool washCurtains = false;
  bool washCarpets = false;
  bool washBedding = false;
  bool ironClothes = false;

  // ข้อมูลการจองคิว
  final List<Map<String, String>> notifications = const [
    {
      'queueNumber': '10',
      'bookingTime': '10:30 น.',
      'bookingDate': '20 ตุลาคม 2024',
    },
    {
      'queueNumber': '12',
      'bookingTime': '11:00 น.',
      'bookingDate': '20 ตุลาคม 2024',
    },
    {
      'queueNumber': '15',
      'bookingTime': '12:00 น.',
      'bookingDate': '20 ตุลาคม 2024',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/menu');
        break;
      case 1:
        Navigator.of(context).pushNamed('/profilepage');
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).pushNamed('/bookinghistory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การแจ้งเตือนคิว'),
        backgroundColor: const Color.fromARGB(255, 94, 201, 112),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_active,
                      color: Colors.green),
                  title: Text('ลำดับคิวที่: ${notifications[index]['queueNumber']}'),
                  subtitle: Text(
                      'วันที่จอง: ${notifications[index]['bookingDate']}\nเวลาจอง: ${notifications[index]['bookingTime']}'),
                  onTap: () {
                    _showNotificationDetails(
                      context,
                      notifications[index]['queueNumber']!,
                      notifications[index]['bookingDate']!,
                      notifications[index]['bookingTime']!,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _editBooking(context, index);
                      },
                      child: const Text('แก้ไขการจองคิว'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        _cancelBooking(context, index);
                      },
                      child: const Text('ยกเลิกคิว', style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, String queueNumber,
      String bookingDate, String bookingTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายละเอียดการจองคิว'),
          content: Text(
              'ลำดับคิวที่: $queueNumber\nวันที่จอง: $bookingDate\nเวลาจอง: $bookingTime'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  void _editBooking(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('แก้ไขการจองคิว'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('ซักผ้าและอบผ้า'),
                    value: washClothes,
                    onChanged: (bool? value) {
                      setState(() {
                        washClothes = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('ซักผ้าม่าน'),
                    value: washCurtains,
                    onChanged: (bool? value) {
                      setState(() {
                        washCurtains = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('ซักพรม'),
                    value: washCarpets,
                    onChanged: (bool? value) {
                      setState(() {
                        washCarpets = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('ซักผ้าปูที่นอน'),
                    value: washBedding,
                    onChanged: (bool? value) {
                      setState(() {
                        washBedding = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('รีดผ้า'),
                    value: ironClothes,
                    onChanged: (bool? value) {
                      setState(() {
                        ironClothes = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('บันทึก'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ยกเลิก'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cancelBooking(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยกเลิกการจองคิว'),
          content: const Text('คุณต้องการยกเลิกคิวนี้หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิกคิว', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }
}

