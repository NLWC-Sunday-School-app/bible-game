import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(2); // Default index is Home (2)

  void selectTab(int index) {
    emit(index);
  }
}
