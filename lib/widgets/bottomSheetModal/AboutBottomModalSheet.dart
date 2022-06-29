import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutBottomModalSheet extends StatelessWidget {
  const AboutBottomModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0.h, bottom: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0.w, right: 125.w),
                      child: Image.asset('assets/images/cancel.png', width: 12.w,),
                    ),
                  ),
                  Text(
                    'About',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                children: [
                  Divider(),
                  SizedBox(height: 20.h,),
                  Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sapien, montes, orci, orci dui quisque pretium. Massa, quam pharetra, ac nec proin. Ut aliquam sit cursus tellus, id ut vestibulum vitae. Sodales lacus, accumsan velit a et, condimentum at gravida pharetra. Auctor lectus tellus, enim nisl pretium diam enim, platea dolor.Diam dolor eget tellus at fermentum. Viverra sed commodo nisi elementum odio tincidunt massa fames. Et proin elementum odio tristique ipsum, ipsum ut. Amet, eu aliquet libero volutpat non. In integer nunc donec viverra. Egestas tincidunt gravida scelerisque ut id sagittis. Dui tempor, aliquet tellus nulla sem at ipsum urna. Blandit augue in in est aliquam feugiat. Eget volutpat massa non quis. Laoreet eleifend nascetur odio urna.Vitae aliquam arcu euismod sit diam in orci. Elit sit tortor diam vestibulum. Vulputate purus aliquet mauris cras lacus molestie. Ultrices amet arcu bibendum volutpat a tincidunt. Sit lorem hac dolor sed. Nunc, at at odio lacus mollis. Sit volutpat ultricies risus commodo lacus lobortis enim. Vestibulum volutpat et tortor non euismod eget ac. Lectus faucibus at lorem posuere lorem posuere et, eget. Sed dictumst ultrices nibh ornare mi nisl. Eros ipsum ut mi a sed sit. Felis euismod adipiscing non nibh lacus, vehicula pellentesque turpis.=Ut facilisi facilisis scelerisque volutpat, phasellus ultricies morbi mauris, viverra. Neque enim adipiscing enim, pharetra, velit. Donec commodo suspendisse ut sodales elementum integer elementum. Arcu sapien convallis ac et dignissim. Neque, at amet facilisi ipsum nibh platea egestas commodo venenatis. Gravida neque feugiat vehicula quis eu neque. Congue facilisis senectus vulputate dictum cras. Faucibus egestas porta aenean diam elementum, viverra orci, lacinia enim. Sed nibh pulvinar hendrerit sit gravida elementum donec in tincidunt. Mauris magna morbi sit quisque cum diam vulputate morbi. Lectus leo a, vel, suscipit lectus platea etiam quis. Ullamcorper posuere massa vitae mauris ac. Mauris viverra scelerisque adipiscing diam.Adipiscing integer accumsan amet, donec eget at curabitur arcu vulputate. Felis in metus, vel faucibus nibh aenean euismod sit. Commodo mi posuere iaculis consequat condimentum at a, arcu malesuada. Elit a, ut quam amet euismod facilisi nisl amet. Quis scelerisque eu elementum faucibus consequat. Ac pharetra neque, id libero. Neque faucibus aliquam amet, venenatis fermentum, est. Cras et ac vel cras cras sapien mauris mi pulvinar.')

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
