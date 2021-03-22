import 'package:flutter/material.dart';

class HeaderListView extends StatelessWidget {
  final Widget header;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  HeaderListView({this.header, this.itemCount, this.itemBuilder});

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
        SliverList(
          delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: itemCount
          ),
        ),
      ],
    );
  }
}
