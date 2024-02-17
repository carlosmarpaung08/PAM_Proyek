import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itdel/Mahasiswa/model/izinbermalam.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Mahasiswa/service/izinbermalam_services.dart';
import 'package:itdel/Autentikasi/Login/login_screen.dart';
import 'package:itdel/global.dart';
import 'package:itdel/Autentikasi/Login/login_services.dart';
import 'package:itdel/Mahasiswa/screen/FormIzinBermalam.dart';

class IzinBermalamScreen extends StatefulWidget {
  @override
  _IzinBermalamScreenState createState() => _IzinBermalamScreenState();
}

class _IzinBermalamScreenState extends State<IzinBermalamScreen> {
  List<dynamic> _izinbermalamlist = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getIzinBermalam();

      if (response.error == null) {
        setState(() {
          _izinbermalamlist = response.data as List<dynamic>;
          _loading = _loading ? !_loading : _loading;
        });
      } else if (response.error == unauthrorized) {
        logout().then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              )
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in retrievePosts: $e");
    }
  }

  void _navigateToAddData() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormIzinBermalams(
              title: 'Request Izin Bermalam',
            )));
  }

  void DeleteIzinBermalam(int id) async {
    try {
      ApiResponse response = await deleteIzinBermalam(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        retrievePosts();
      } else if (response.error == unauthrorized) {
        // ... (unchanged)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteIzinBermalam: $e");
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Izin Bermalam'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Reason')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _izinbermalamlist
                    .map(
                      (izinBermalam) => DataRow(
                        cells: [
                          DataCell(Text(
                              '${_izinbermalamlist.indexOf(izinBermalam) + 1}')),
                          DataCell(Text(izinBermalam.reason)),
                          DataCell(Text(izinBermalam.status)),
                          DataCell(
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    child: Text('Edit'),
                                    value: 'edit',
                                  ),
                                  PopupMenuItem(
                                    child: Text('View'),
                                    value: 'view',
                                  ),
                                  PopupMenuItem(
                                    child: Text('Cancel'),
                                    value: 'delete',
                                  ),
                                ];
                              },
                              onSelected: (String value) {
                                if (value == 'edit') {
                                  int index =
                                      _izinbermalamlist.indexOf(izinBermalam);
                                  RequestIzinBermalam selectedIzinBermalam =
                                      _izinbermalamlist[index];

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FormIzinBermalams(
                                      title: "Edit Izin Bermalam",
                                      formIzinBermalam: selectedIzinBermalam,
                                    ),
                                  ));
                                } else if (value == 'view') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("View Izin Bermalam"),
                                        content: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columns: [
                                              DataColumn(
                                                  label: Text('Information')),
                                              DataColumn(
                                                  label: Text('Details'),
                                                  numeric: true),
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                DataCell(Text('Reason')),
                                                DataCell(
                                                    Text(izinBermalam.reason)),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Start Date')),
                                                DataCell(Text(
                                                    DateFormat('dd MMMM yyyy')
                                                        .format(izinBermalam
                                                            .startDate))),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('End Date')),
                                                DataCell(Text(DateFormat(
                                                        'dd MMMM yyyy')
                                                    .format(
                                                        izinBermalam.endDate))),
                                              ]),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Izin Bermalam"),
                                        content: Text(
                                            "Are you sure you want to delete this request?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close confirmation dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              DeleteIzinBermalam(
                                                  izinBermalam.id ?? 0);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddData,
        child: Icon(Icons.add),
      ),
    );
  }
}
