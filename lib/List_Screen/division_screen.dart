import 'dart:io';
import 'package:adikris_211510007/CS_Screen/edit_customer.dart';
import 'package:adikris_211510007/CS_Screen/formcs.dart';
import 'package:adikris_211510007/dto/cs.dart';
import 'package:adikris_211510007/dto/division.dart';
import 'package:adikris_211510007/dto/division.dart';
import 'package:adikris_211510007/endpoints/endpoints.dart';
import 'package:adikris_211510007/services/data_service.dart';
import 'package:adikris_211510007/utils/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({Key? key}) : super(key: key);

  @override
  _DivisionScreenState createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> with WidgetsBindingObserver {
  Future<List<Division>>? division;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    division = DataService.fetchDivision();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Division List"),
          backgroundColor: Color.fromARGB(255, 255, 255, 255), // Updated color
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder<List<Division>>(
            future: division,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in data)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5), // Updated color
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: const Color(0xFFE0E0E0)), // Updated color
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.business, color: Color(0xFF0D47A1)), // Updated color
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  'Division: ${item.divisionDepartmentName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: const Color(0xFF333333), // Updated color
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}