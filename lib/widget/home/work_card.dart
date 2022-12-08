import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:flutter/material.dart';

class WorkCard extends StatelessWidget {
  final String workOrStudy;
  final bool isStudying;
  const WorkCard({Key key, this.workOrStudy, this.isStudying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        height: getScreenSize(context).height * 0.15,
        width: getScreenSize(context).width * 0.26,
        padding: EdgeInsets.all(getScreenSize(context).height * 0.015),
        decoration: BoxDecoration(
          color: Colors.cyan[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  workOrStudy,
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 2.8,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: ImageIcon(
                    isStudying
                        ? AssetImage(placeOfStudyIcon)
                        : AssetImage(placeOfWorkIcon),
                    size: SizeConfig.blockSizeHorizontal * 8,
                    color: Colors.white.withOpacity(0.9),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
