import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

void showFourScripturesOneWordTourGuidModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return TourWelcomeModal();
      });
}

class TourWelcomeModal extends StatefulWidget {
  const TourWelcomeModal({
    Key? key,
  }) : super(key: key);

  @override
  State<TourWelcomeModal> createState() => _TourWelcomeModalState();
}

class _TourWelcomeModalState extends State<TourWelcomeModal> {
  bool isShowingHowItWorks = true;
  bool isDisplayingShowMe = false;
  bool isShowingFirstGuide = false;
  bool isShowingSecondGuide = false;
  bool isShowingThirdGuide = false;
  bool isShowingGuide = false;

  displayHowItWorks() {
    setState(() {
      isShowingHowItWorks = false;
      isDisplayingShowMe = true;
    });
  }

  startGameTour() {
    setState(() {
      isShowingHowItWorks = false;
      isDisplayingShowMe = false;
      isShowingFirstGuide = true;
    });
  }

  showSecondGuide() {
    setState(() {
      isShowingHowItWorks = false;
      isDisplayingShowMe = false;
      isShowingFirstGuide = false;
      isShowingSecondGuide = true;
    });
  }

  showThirdGuide() {
    setState(() {
      isShowingHowItWorks = false;
      isDisplayingShowMe = false;
      isShowingFirstGuide = false;
      isShowingSecondGuide = false;
      isShowingThirdGuide = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticationState =
        BlocProvider.of<AuthenticationBloc>(context).state;
    return SizedBox(
      height: Get.height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(39, 97, 164, 1).withOpacity(
                  isShowingHowItWorks || isDisplayingShowMe ? 0.8 : 0.5),
              const Color.fromRGBO(39, 97, 164, 0).withOpacity(
                  isShowingHowItWorks || isDisplayingShowMe ? 0.9 : 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 40.w,
              vertical: isShowingFirstGuide
                  ? 100.h
                  : isShowingSecondGuide
                      ? (Get.height < 700 ? 35.h : 80.h)
                      : 90.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isShowingFirstGuide
                  ? Image.asset(
                      ProductImageRoutes.arrowOne,
                      width: 230.w,
                    )
                  : isShowingSecondGuide
                      ? Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Image.asset(
                              ProductImageRoutes.arrowTwo,
                              width: 50.w,
                            ),
                          ),
                        )
                      : const SizedBox(),
              Text(
                isShowingHowItWorks
                    ? 'Welcome ${authenticationState.user!.name}'
                    : isDisplayingShowMe
                        ? 'Welcome ${authenticationState.user!.name}'
                        : isShowingFirstGuide
                            ? 'Read scriptures'
                            : isShowingSecondGuide
                                ? 'Your answer \ngoes here'
                                : isShowingThirdGuide
                                    ? 'Have fun with \nyour friends!'
                                    : '',
                style: TextStyle(
                    fontSize: 24.sp, letterSpacing: 1, color: Colors.white, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                isShowingHowItWorks
                    ? 'Let me explain how the game \nworks!'
                    : isDisplayingShowMe
                        ? 'You get 4 scriptures and you type \nin 1 word that the scriptures share \nin common! First, some tips you will \nneed'
                        : isShowingFirstGuide
                            ? 'You can read the scriptures by \nclicking on the text or boxes, \nIt’s super easy!'
                            : isShowingSecondGuide
                                ? 'Click the boxes to type in your \nanswer to the question'
                                : isShowingThirdGuide
                                    ? 'Not sure what the answer is? \nClick this button to get your \nfriends to help you out!'
                                    : '',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => {
                      isShowingHowItWorks
                          ? displayHowItWorks()
                          : isDisplayingShowMe
                              ? startGameTour()
                              : isShowingFirstGuide
                                  ? showSecondGuide()
                                  : isShowingSecondGuide
                                      ? showThirdGuide()
                                      : Navigator.pop(context)
                    },
                    child: Container(
                        // width: 155.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        decoration: BoxDecoration(
                            color: const Color(0xFF2761A4),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          children: [
                            Text(
                              isShowingHowItWorks
                                  ? 'How it works'
                                  : isDisplayingShowMe
                                      ? 'Show me!'
                                      : isShowingFirstGuide
                                          ? 'Next tip'
                                          : isShowingSecondGuide
                                              ? 'Next tip'
                                              : isShowingThirdGuide
                                                  ? 'Start playing!'
                                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ),
                  SvgPicture.asset(
                    ProductImageRoutes.broLukeThree,)
                ],
              ),
              isShowingThirdGuide
                  ? Center(
                      child: Image.asset(
                        ProductImageRoutes.arrowThree,
                        width: 120.w,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
