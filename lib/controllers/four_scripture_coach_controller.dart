import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class FourScripturesCoachController {

  late TutorialCoachMark tutorialCoachMark;
  showTutorial(context) {
    tutorialCoachMark.show(context: context);
  }

  createTutorial(scriptureTileKey, inputFieldKey, shareButtonKey) {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(scriptureTileKey, inputFieldKey, shareButtonKey),
      colorShadow:  const Color(0xFF27AE60),
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets(scriptureTileKey, inputFieldKey, shareButtonKey  ) {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: scriptureTileKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Home",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Tap this button to view the number of notifications received on your account",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: inputFieldKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Home",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Tap this button to view the number of notifications received on your account",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: shareButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Home",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                Text(
                  "Tap this button to view the number of notifications received on your account",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return targets;
  }

}