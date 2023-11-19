part of merge_table;

abstract class BaseMColumn {
  final String header;
  final Color? color;
  final List<String>? columns;

  bool get isMergedColumn => columns != null;

  BaseMColumn({required this.header, this.color, this.columns});
}

class MColumn extends BaseMColumn {
  MColumn({required String header, Color? color})
      : super(header: header, color: color, columns: null);
}

class MMergedColumns extends BaseMColumn {
  @override
  List<String> get columns => super.columns!;

  MMergedColumns(
      {required String header, required List<String> columns, Color? color})
      : super(columns: columns, header: header, color: color);
}
