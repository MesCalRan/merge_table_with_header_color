part of merge_table;

class MergeTable extends StatelessWidget {
  MergeTable({
    Key? key,
    required this.rows,
    required this.columns,
    required this.borderColor,
    this.rowHeight,
    this.headerHeight,
    this.headerTextStyle,
    this.alignment = MergeTableAlignment.center,
  }) : super(key: key) {
    columnWidths = fetchColumnWidths(columns);
    assert(columns.isNotEmpty);
    assert(rows.isNotEmpty);
    for (List<BaseMRow> row in rows) {
      assert(row.length == columns.length);
    }
  }

  final Color borderColor;
  final List<BaseMColumn> columns;
  final List<List<BaseMRow>> rows;
  final MergeTableAlignment alignment;
  final double? rowHeight;
  final double? headerHeight;
  final TextStyle? headerTextStyle;
  late final Map<int, TableColumnWidth> columnWidths;

  TableCellVerticalAlignment get defaultVerticalAlignment =>
      alignment.tableAlignment;

  AlignmentGeometry get alignmentGeometry => alignment.geometry;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: columnWidths,
      defaultVerticalAlignment: defaultVerticalAlignment,
      children: [
        buildHeader(),
        ...buildRows(),
      ],
    );
  }

  TableRow buildHeader() {
    return TableRow(
      children: List.generate(
        columns.length,
        (index) {
          BaseMColumn column = columns[index];
          if (column.columns != null) {
            return buildMergedColumn(
              column: column,
              height: headerHeight,
              textStyle: headerTextStyle,
            );
          } else {
            return Container(
              height: headerHeight != null ? headerHeight! * 2 : null,
              child: buildSingleColumn(
                title: column.header,
                color: column.color,
                textStyle: headerTextStyle,
              ),
            );
          }
        },
      ),
    );
  }

  List<TableRow> buildRows() {
    return List.generate(
      rows.length,
      (index) {
        List<BaseMRow> values = rows[index];
        return TableRow(
          children: List.generate(
            values.length,
            (index) {
              BaseMRow item = values[index];
              bool isMergedColumn = item.inlineRow.length > 1;
              if (isMergedColumn) {
                return buildMutiColumns(
                  item.inlineRow,
                );
              } else {
                return buildAlign(child: item.inlineRow.first);
              }
            },
          ),
        );
      },
    );
  }

  Widget buildMergedColumn({
    required BaseMColumn column,
    double? height,
    TextStyle? textStyle,
  }) {
    return Column(
      children: [
        Container(
          height: headerHeight,
          child: buildSingleColumn(
            title: column.header,
            color: column.color,
            textStyle: textStyle,
          ),
        ),
        Divider(color: borderColor, height: 1, thickness: 1),
        Container(
          height: headerHeight,
          child: buildMutiColumns(
            List.generate(column.columns!.length, (index) {
              return buildSingleColumn(
                title: column.columns![index],
                color: column.color,
                textStyle: textStyle,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget buildMutiColumns(List<Widget> values) {
    return LayoutBuilder(builder: (context, constraint) {
      List<Widget> children = List.generate(values.length, (index) {
        Widget value = values[index];
        double spaceForBorder = (values.length - 1) / values.length;
        return SizedBox(
          width: constraint.maxWidth / values.length - spaceForBorder,
          child: buildAlign(child: value),
        );
      });
      return Container(
        height: rowHeight,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (Widget child in children.take(children.length - 1)) ...[
                child,
                VerticalDivider(width: 1, color: borderColor, thickness: 1)
              ],
              children.last,
            ],
          ),
        ),
      );
    });
  }

  Widget buildSingleColumn({
    required String title,
    Color? color,
    double? height,
    TextStyle? textStyle,
  }) {
    return buildAlign(
        child: Text(
          title,
          style: textStyle,
        ),
        color: color);
  }

  Widget buildAlign({required Widget child, Color? color}) {
    return Container(
      color: color,
      alignment: alignmentGeometry,
      child: child,
    );
  }

  Map<int, TableColumnWidth> fetchColumnWidths(List<BaseMColumn> columns) {
    Map<int, TableColumnWidth> columnWidths = {};
    double flexPerColumn = 1 / columns.length;
    for (int i = 0; i < columns.length; i++) {
      BaseMColumn column = columns[i];
      if (column.isMergedColumn) {
        columnWidths[i] =
            FlexColumnWidth(flexPerColumn * column.columns!.length);
      } else {
        columnWidths[i] = FlexColumnWidth(flexPerColumn);
      }
    }
    return columnWidths;
  }
}
