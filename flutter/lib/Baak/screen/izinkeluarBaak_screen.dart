import 'package:flutter/material.dart';
import 'package:itdel/api_response.dart';
import 'package:itdel/Baak/model/izinkeluarBaak.dart';
import 'package:itdel/Baak/service/izinkeluarBaak_services.dart';

class IzinKeluarBaakView extends StatefulWidget {
  @override
  _IzinKeluarBaakViewState createState() => _IzinKeluarBaakViewState();
}

class _IzinKeluarBaakViewState extends State<IzinKeluarBaakView> {
  late Future<ApiResponse<List<IzinKeluar>>> _izinKeluarData;

  @override
  void initState() {
    super.initState();
    _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Izin Keluar Baak'),
      ),
      body: FutureBuilder<ApiResponse<List<IzinKeluar>>>(
        future: _izinKeluarData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.error != null) {
            return Center(child: Text('Failed to load data.'));
          } else {
            List<IzinKeluar> izinKeluarList = snapshot.data!.data!;
            return ListView.builder(
              itemCount: izinKeluarList.length,
              itemBuilder: (context, index) {
                IzinKeluar izinKeluar = izinKeluarList[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('ID: ${izinKeluar.userId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason: ${izinKeluar.reason}'),
                        Text('Status: ${izinKeluar.status}'),
                        Text('Start Date: ${izinKeluar.startDate}'),
                        Text('End Date: ${izinKeluar.endDate}'),
                        // Add other widgets as needed
                      ],
                    ),
                    trailing: izinKeluar.status == 'approved'
                        ? null
                        : ElevatedButton(
                            onPressed: () {
                              approveIzin(izinKeluar.id);
                            },
                            child: Text('Approve'),
                          ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void approveIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinKeluarBaakController.approveIzinKeluar(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
      });
    }
  }
}
