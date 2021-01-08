import 'package:flutter/material.dart';

class HomeScrollView extends StatelessWidget {
  Widget header;
  Function(BuildContext, int) itemBuilder;
  int itemCount;

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
