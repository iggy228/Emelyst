import 'package:flutter/material.dart';

class HeaderGridView extends StatelessWidget {
  final Widget header;
  final Widget floorHeader;
  final int floorCount;
  final Widget Function(BuildContext context, int index) floorBuilder;
  final Widget roomHeader;
  final int roomCount;
  final Widget Function(BuildContext, int index) roomBuilder;

  HeaderGridView({
    this.header,
    this.floorHeader,
    this.floorCount,
    this.floorBuilder,
    this.roomHeader,
    this.roomCount,
    this.roomBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              header,
              floorHeader,
            ],
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildBuilderDelegate(
            floorBuilder,
            childCount: floorCount,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              roomHeader,
            ],
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildBuilderDelegate(
            roomBuilder,
            childCount: roomCount,
          ),
        ),
      ],
    );
  }
}
