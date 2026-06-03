import 'dart:convert';
import 'dart:developer';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/presentation/main/news_details_screen/bloc/news_details_screen_bloc_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../core/utils/app_functions.dart';
import '../../../../data/models/event_news_model.dart';
import '../../../../data/models/post_comment_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'news_screen_bloc_cubit.freezed.dart';
part 'news_screen_bloc_state.dart';

class NewsScreenBlocCubit extends Cubit<NewsScreenBlocState> {
  NewsScreenBlocCubit() : super(const NewsScreenBlocState());

  init() {
    emit(state.copyWith(
      isLoading: false,
      eventPostList: [],
      isReplyComment: false,
      currentPage: 1,
      isBottomLoading: false,
    ));
  }

  changeReplyCommentStatus(bool status) {
    emit(state.copyWith(isReplyComment: status));
  }

  changeType(String type) {
    emit(state.copyWith(type: type));
  }

  Future<void> getNewsEvents(String type,
      {int page = 1, String postType = "incident"}) async {
    emit(state.copyWith(isLoading: page == 1, isBottomLoading: page > 1));
    try {
      // Fetch data from API with the current page number
      ResponseModel response =
          await MainRepository.eventNewsList(type, page, postType: postType);

      if (response.status == true && response.body != null) {
        EventNewsModel alertModel = EventNewsModel.fromJson(response.toJson());

        List<EventNewsData> eventNews = alertModel.body?.data ?? [];
        int currentPage = alertModel.body?.page ?? 1;
        int totalPage = alertModel.body?.totalPages ?? 1;

        if (currentPage == 1) {
          emit(state.copyWith(
            eventPostList: eventNews,
            isLoading: false,
            isBottomLoading: false,
            currentPage: currentPage,
            totalPages: totalPage,
          ));
          return;
        } else {
          // Check if it's the first page or if we are appending data
          List<EventNewsData> updatedList = List.from(state.eventPostList!)
            ..addAll(eventNews);
          emit(state.copyWith(
            eventPostList: updatedList,
            isLoading: false,
            isBottomLoading: false,
            currentPage: currentPage,
            totalPages: totalPage,
          ));
          return;
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          isBottomLoading: false,
        ));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isBottomLoading: false,
      ));
      log('Error fetching event news: ${e.toString()}');
    }
    // emit(state.copyWith(isLoading: page == 1, isBottomLoading: page > 1));
  }

  updateNewsListReactionCount(
      String postId, String newReactionCount, bool isReacted) {
    final updatedList = state.eventPostList?.map((post) {
      if (post.id == postId) {
        return post.copyWith(
            reactionCounts: newReactionCount, hasReacted: isReacted);
      }
      return post;
    }).toList();
    emit(state.copyWith(
      eventPostList: updatedList,
    ));
  }

  updateNewsListCommentCount(String postId, String newReactionCount) {
    final updatedList = state.eventPostList?.map((post) {
      if (post.id == postId) {
        return post.copyWith(commentCounts: newReactionCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(eventPostList: updatedList));
  }

  // Function to load more data when user scrolls
  Future<void> loadMoreEventNews(String postType) async {
    if (state.currentPage < state.totalPages) {
      // Fetch the next page
      await getNewsEvents(state.type,
          page: state.currentPage + 1, postType: postType);
    }
  }

/*  Future<void> startNewsEventListIsolate(List<dynamic> apiData) async {
    final ReceivePort receivePort = ReceivePort();
    // Spawn the isolate
    await Isolate.spawn(parseNewsEventListData, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();
    sendPort.send([apiData, responsePort.sendPort]);
    responsePort.listen((processedData) {
      List<EventNewsData> tempList = processedData;
      emit(state.copyWith(isLoading: false, eventPostList: tempList));
    });
  }

  static void parseNewsEventListData(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    final message = await receivePort.first;
    List<dynamic> apiData = message[0];

    List<dynamic> recentData = apiData;
    List<EventNewsData> recentMatches =
        recentData.map((e) => EventNewsData.fromJson(e)).toList();
    final SendPort replyPort = message[1];
    replyPort.send(recentMatches);
  }*/

  void onPageChanged(
    int index,
  ) {
    emit(state.copyWith(attachmentCurrentIndex: index));
  }

  Future<void> getPostComments(String postId) async {
    emit(state.copyWith(isCommentLoading: true));
    try {
      ResponseModel response =
          await MainRepository.eventPostCommentList(postId);
      if (response.status == true && response.body != null) {
        PostCommentModel eventNewsModel =
            PostCommentModel.fromJson(response.toJson());
        List<PostCommentData> tempList = eventNewsModel.body ?? [];
        emit(state.copyWith(
            isCommentLoading: false, eventPostCommentList: tempList));
      } else {
        emit(state.copyWith(isCommentLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isCommentLoading: false,
      ));
      log('Cache Error ${e.toString()}');
    }
  }

  setLikeAnimation(String postId, bool value) {
    final updatedList = state.eventPostList?.map((post) {
      if (post.id == postId) {
        return post.copyWith(isAnimate: value);
      }
      return post;
    }).toList();
    emit(state.copyWith(
      eventPostList: updatedList,
    ));
  }

  setISReactedOrNot(bool isReacted) {
    emit(state.copyWith(
      isReacted: isReacted,
    ));
  }

  late io.Socket socket;

  // Send comment request
  sendComment(
      {required String eventPostId,
      required String userId,
      required String comment}) {
    emitRequest("sendEventPostComment",
        {"eventPostId": eventPostId, "comment": comment, "userId": userId});
  }

  // Send reply comment request
  sendReplyComment(
      {required String eventPostId,
      required String userId,
      required String commentId,
      required String comment}) {
    emitRequest("sendEventPostCommentReply", {
      "eventPostId": eventPostId,
      "commentId": commentId,
      "commentReply": comment,
      "userId": userId
    });
  }

  // Send like comment request
  likeComment(
      {required String eventPostId,
      required String userId,
      required String commentId}) {
    emitRequest("likeEventPostComment",
        {"eventPostId": eventPostId, "commentId": commentId, "userId": userId});
  }

  // Send unb like comment request
  unLikeComment(
      {required String eventPostId,
      required String userId,
      required String commentId}) {
    emitRequest("unlikeEventPost",
        {"eventPostId": eventPostId, "commentId": commentId, "userId": userId});
  }

  // Send like reply comment request
  likeReplyComment(
      {required String eventPostId,
      required String userId,
      required String replyCommentId,
      required String commentId}) {
    emitRequest("likeEventPostCommentReply", {
      "eventPostId": eventPostId,
      "commentId": commentId,
      "replyId": replyCommentId,
      "userId": userId
    });
  }

  // Send Un like reply comment request
  unLikeReplyComment(
      {required String eventPostId,
      required String userId,
      required String replyCommentId,
      required String commentId}) {
    emitRequest("unlikeEventPostComment", {
      "eventPostId": eventPostId,
      "commentId": commentId,
      "replyId": replyCommentId,
      "userId": userId
    });
  }

  //  Delete comment request
  deleteComment(
      {required String eventPostId,
      required String userId,
      required String commentId}) {
    emitRequest("deleteEventPostComment",
        {"eventPostId": eventPostId, "commentId": commentId, "userId": userId});
  }

  // Delete comment request
  deleteReplyComment(
      {required String eventPostId,
      required String userId,
      required String replyCommentId,
      required String commentId}) {
    emitRequest("deleteEventPostCommentReply", {
      "eventPostId": eventPostId,
      "commentId": commentId,
      "replyId": replyCommentId,
      "userId": userId
    });
  }

  emitRequest(String event, Map<String, dynamic> message) {
    socket.emit(event, message);
  }

  connectSocketIo(BuildContext context, String postId) {
    try {
      socket = io.io(
          baseUrl,
          io.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              .build());

      socket.on(
        "connect",
        (data) {
          log("====Comment Socket is connected ====");
        },
      );

      socket.on(
        "disconnect",
        (data) async {
          log("====Comment Socket is Dis-Connected ====");
        },
      );

      socket.on(
        "receiveEventPostComment",
        (data) {
          try {
            if (data != null) {
              List<PostCommentData> tempList =
                  eventNewsDetailModelFromJson(jsonEncode(data['comments']));
              context
                  .read<NewsDetailsScreenBlocCubit>()
                  .updateCommentCount(data['totalCommentCounts'].toString());
              updateNewsListCommentCount(
                  postId, data['totalCommentCounts'].toString());
              emit(state.copyWith(
                  isCommentLoading: false, eventPostCommentList: tempList));
            }
          } catch (error) {
            log("Comment socket error === ${error.toString()}");
          }
        },
      );
    } catch (e) {
      log('Catch Error : ${e.toString()}');
    }
  }

  disconnectSocketIo() {
    io.io(socket.disconnect());
  }
}
