import 'package:flutter/material.dart';

class HeaderGridView extends StatelessWidget {
  final Widget header;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  HeaderGridView({this.header, this.itemCount, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              header,
            ],
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: itemCount
          ),
        ),
      ],
    );
  }
}
