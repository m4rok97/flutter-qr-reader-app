import 'package:flutter/material.dart';
import 'package:qr_reader_app/bloc/scan_bloc.dart';
import 'package:qr_reader_app/models/scan_model.dart';
import 'package:qr_reader_app/utils/utils.dart';

class DataPage extends StatelessWidget {
  final scansBloc = new ScansBloc();
  final String pageName;

  DataPage(this.pageName);

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();

    final stream = pageName == 'geo'
        ? scansBloc.scansStreamGeo
        : scansBloc.scansStreamHttp;

    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Text('No hay informacion');
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
            child: ListTile(
              leading: Icon(
                Icons.cloud_queue,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => openScan(context, scans[i]),
            ),
          ),
        );
      },
    );
  }
}
