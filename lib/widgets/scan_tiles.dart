import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;
  const ScanTiles({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (DismissDirection direction) async {
          final int? j = scans[i].id;
          if (j != null) {
            await Provider.of<ScanListProvider>(context, listen: false)
                .borrarScanPorId(j);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
                  color: const Color(0xFF00897B),
                  size: 24,
                ),
              ),
              title: Text(
                scans[i].valor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'ID: ${scans[i].id}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey[400],
                size: 24,
              ),
              onTap: () => launchURL(context, scans[i]),
            ),
          ),
        ),
      ),
    );
  }
}
