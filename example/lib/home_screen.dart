import 'package:flutter/material.dart';
import 'package:merge_table/merge_table.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: buildMergeTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMergeTable() {
    return MergeTable(
      borderColor: Colors.black,
      alignment: MergeTableAlignment.center,
      columns: [
        MColumn(header: "RED", color: Colors.red),
        MColumn(header: "GREEN", color: Colors.green),
        MColumn(header: "BLUE", color: Colors.blue),
        MMergedColumns(
          header: "3 Words",
          color: Colors.orange,
          columns: ["Before", "Then", "After"],
        ),
        MColumn(header: "Yellow", color: Colors.yellow),
      ],
      rows: [
        [
          MRow(const Text("1")),
          MRow(const Text("2")),
          MRow(const Text("3")),
          MMergedRows([
            const Text("4"),
            const Text("5"),
            const Text("8"),
          ]),
          MRow(const Text("6")),
        ],
        [
          MRow(const Text("1")),
          MRow(const Text("2")),
          MRow(const Text("3")),
          MMergedRows([
            const Text("4"),
            const Text("5"),
            const Text("8"),
          ]),
          MRow(const Text("6")),
        ],
      ],
    );
  }
}
