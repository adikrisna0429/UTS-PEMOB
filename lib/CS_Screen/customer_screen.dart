import 'dart:io';
import 'package:adikris_211510007/CS_Screen/edit_customer.dart';
import 'package:adikris_211510007/CS_Screen/formcs.dart';
import 'package:adikris_211510007/dto/cs.dart';
import 'package:adikris_211510007/dto/division.dart';
import 'package:adikris_211510007/dto/priorities.dart';
import 'package:adikris_211510007/endpoints/endpoints.dart';
import 'package:adikris_211510007/services/data_service.dart';
import 'package:adikris_211510007/utils/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> with WidgetsBindingObserver {
  Future<List<CustomerService>>? newcs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    newcs = DataService.fetchCustomerService();
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
          title: Text("Layanan Aduan PT. Nusa Abadi "),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        drawer: CustomDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0D47A1),
          tooltip: 'Add New Customer Service',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormScreen()),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: FutureBuilder<List<CustomerService>>(
              future: newcs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      for (final item in data)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.imageUrl != null)
                                  Container(
                                    margin: EdgeInsets.only(right: 16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        Uri.parse('${Endpoints.baseURL}/public/${item.imageUrl!}')
                                            .toString(),
                                        width: 100,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Issue: ${item.titleIssues}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Description: ${item.descriptionIssues}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: item.rating.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                item.rating = rating.toInt();
                                              });
                                            },
                                          ),
                                          Row(
                                            children: [
                                                                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => EditDatas(
                                                        idCustomerService: item.idCustomerService,
                                                        title: item.titleIssues,
                                                        description: item.descriptionIssues,
                                                        rating: item.rating,
                                                        selectedPriority: Priority(priorityName: item.priority),
                                                        selectedDepartment: Division(divisionDepartmentName: item.department),
                                                        imageFile: item.imageUrl != null ? File(item.imageUrl!) : null,
                                                        onSave: (title, description, rating, selectedPriority, selectedDepartment, imageFile) {
                                                          setState(() {
                                                            item.titleIssues = title;
                                                            item.descriptionIssues = description;
                                                            item.rating = rating;
                                                            item.priority = selectedPriority.priorityName!;
                                                            item.department = selectedDepartment.divisionDepartmentName!;
                                                            item.imageUrl = imageFile != null ? imageFile.path : null;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  bool confirm = await showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Confirm Deletion'),
                                                        content: Text('Are you sure you want to delete this item?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(false);
                                                            },
                                                            child: Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(true);
                                                            },
                                                            child: Text('Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (confirm) {
                                                    DataService.deleteCustomerService(item.idCustomerService).then((_) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Data successfully deleted'),
                                                        ),
                                                      );
                                                      setState(() {
                                                        newcs = DataService.fetchCustomerService();
                                                      });
                                                    }).catchError((error) {
                                                      print('Error deleting data: $error');
                                                    });
                                                  }
                                                },
                                                icon: Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}