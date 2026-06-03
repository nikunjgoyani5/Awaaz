import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_friend_screen_bloc_state.dart';
part 'add_friend_screen_bloc_cubit.freezed.dart';

class AddFriendScreenBlocCubit extends Cubit<AddFriendScreenBlocState> {
  AddFriendScreenBlocCubit() : super(const AddFriendScreenBlocState.initial());
}
