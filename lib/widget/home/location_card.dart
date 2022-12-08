import 'package:antizero_jumpin/handler/home.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatefulWidget {
  final Map<String, dynamic> currentUserGeo;
  final Map<String, dynamic> anotherUserGeo;
  final String distance;

  const LocationCard(
      {Key key, this.currentUserGeo, this.anotherUserGeo, this.distance})
      : super(key: key);

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  bool calcDistance = false;
  String distance;

  @override
  void initState() {
    if (widget.distance == null) setDistance();
    super.initState();
  }

  setDistance() async {
    if (widget.currentUserGeo != null && widget.anotherUserGeo != null) {
      double dist = await calculateDistance(
          startLat: widget.currentUserGeo['Lat'],
          startLong: widget.currentUserGeo['Long'],
          endLat: widget.anotherUserGeo['Lat'],
          endLong: widget.anotherUserGeo['Long']);
      if (dist != null) distance = '${(dist / 1000).toStringAsFixed(2)} Km';
      calcDistance = true;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: size.width * 0.04,
          height: size.height * 0.03,
          child: Image.asset(
            locationNIcon,
          ),
        ),
        SizedBox(width: 2),
        Flexible(
          child: Text(
              widget.distance != null ? widget.distance : distance ?? "N/A",
              textScaleFactor: 1,
              overflow: TextOverflow.visible,
              maxLines: 10,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
