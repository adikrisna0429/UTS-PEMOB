import 'package:adikris_211510007/CS_Screen/customer_screen.dart';
import 'package:adikris_211510007/List_Screen/division_screen.dart';
import 'package:adikris_211510007/List_Screen/priority_screen.dart';
import 'package:flutter/material.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0D47A1), // Warna biru tua
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'PT. Nusa Abadi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: Text('Beranda', style: TextStyle(color: Color(0xFF0D47A1), fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CustomerScreen()),
              );
            },

                ),
                ListTile(
                  title: Text('Prioritas', style: TextStyle(color: Color(0xFF0D47A1), fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PriorityScreen()),
              );
            },
                ),
                ListTile(
                  title: Text('Divisi', style: TextStyle(color: Color(0xFF0D47A1), fontSize: 16)),
              onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DivisionScreen()),
              );
            },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}