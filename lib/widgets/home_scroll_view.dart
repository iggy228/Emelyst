import 'package:flutter/material.dart';

class HomeScrollView extends StatelessWidget {
  final Widget header;
  final Function(BuildContext, int) itemBuilder;
  final int itemCount;

  HomeScrollView({this.header, this.itemCount, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              header,
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: itemCount,
          ),
        ),
      ],
    );
  }
}
