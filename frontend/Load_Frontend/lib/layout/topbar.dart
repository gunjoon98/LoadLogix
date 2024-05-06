import 'package:flutter/material.dart';
import 'package:load_frontend/constaints.dart';
import 'package:load_frontend/views/news.dart';

import '../views/box_simulation_3d.dart';
import '../views/delivery_simulation_map.dart';

class TopBar extends StatelessWidget {
  final bool _showDesktop;
  const TopBar([this._showDesktop = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: componentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Logistics Optimize Algorithm Dive',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  bottom: 0,
                  left: 0,
                )
              ],
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
              icon: Icon(
                Icons.local_shipping,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.conveyor_belt,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.forklift,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.view_in_ar,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            this._showDesktop
                ? SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      Icons.article_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewsPage()),
                      );
                    },
                  )
          ])
        ],
      ),
    );
  }
}
