class TourWelcomeModal extends StatelessWidget {
  const TourWelcomeModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return SizedBox(
      height: Get.height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(39, 97, 164, 1).withOpacity(0.7),
              const Color.fromRGBO(39, 97, 164, 0).withOpacity(0.9),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 100.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('welcome ${userController.myUser['name']}',
                  style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: 'neuland',
                  color: Colors.white
                ),),
              Text('Let me explain how the game \nworks!', style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),),
              SizedBox(height: 20.h),
              Container(
                width: 155.w,
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2761A4),
                 borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.white)
                ),
                child: Row(
                  children: [
                    Text('How it works', style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp
                    ),),
                    SizedBox(width: 10.w,),
                    const Icon(Icons.arrow_forward, color: Colors.white,)
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}