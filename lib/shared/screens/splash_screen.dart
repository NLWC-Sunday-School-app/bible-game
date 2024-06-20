
import 'package:bible_game_api/bible_game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/utils/network_connection.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/image_routes.dart';
import '../features/authentication/bloc/authentication_bloc.dart';
import '../features/authentication/repository/authentication_repository.dart';
import '../features/user/repository/user_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.splashScreenLoaderBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 70.w),
                child: LinearPercentIndicator(
                    lineHeight: 15.h,
                    percent: 1,
                    animation: true,
                    animationDuration: 500,
                    barRadius: const Radius.circular(10),
                    progressColor: const Color(0xFFFECF75),
                    onAnimationEnd: () => {
                      checkInternetConnection()
                    }),
              ),
              SizedBox(
                height: 50.h,
              )
            ],
          ),
        ),
      ],
    );
  }

  checkInternetConnection() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userToken = prefs.getString('userToken');
    final String? refreshToken = prefs.getString('refreshToken');
     NetworkConnection networkConnection = NetworkConnection();
     if(await networkConnection.hasInternetConnection()){
        if(userToken != null){
          bool tokenHasExpired = JwtDecoder.isExpired(userToken);
          if(tokenHasExpired && refreshToken != null){
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationRefreshTokenRequested(refreshToken));
          }else {
            // print('RESET APP');
          }
          BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
          Navigator.pushNamed(context, AppRoutes.home);
        }else{
          Navigator.pushNamed(context, AppRoutes.home);
        }
     }
  }
}
