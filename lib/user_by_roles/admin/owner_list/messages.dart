import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/chat_message_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message extends StatefulWidget {
  Message(
      {super.key,
      required this.residetName,
      required this.residentId,
      required this.residentDeviseToken});

  int residentId;
  String residentDeviseToken;

  String residetName;

  @override
  State<Message> createState() {
    return _Message();
  }
}

class _Message extends State<Message> with ApiListener {
  final TextEditingController _controllerMessage = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isNetworkConnected = false;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
    _choose();
  }

  int residentId = 0;
  int senderId = 0;
  int apartmentId = 0;

  String enteredMessage = '';

  List<ChatMessageModel> endToEndMessageLists = [];

  @override
  Widget build(BuildContext context) {
    final messageList1 = endToEndMessageLists.reversed.toList();
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: widget.residetName,
          profile: () async {},
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    FontSizeUtil.CONTAINER_SIZE_60,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList1.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messageList1[index];
                      bool isSender = message.senderId == senderId;

                      return Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                          margin: EdgeInsets.symmetric(
                              vertical: FontSizeUtil.SIZE_04),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.blue : Colors.green,
                            borderRadius:
                                BorderRadius.circular(FontSizeUtil.SIZE_10),
                          ),
                          child: Text(
                            message.message!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: const Color(0xff1B5694),
          padding: EdgeInsets.symmetric(
              horizontal: FontSizeUtil.SIZE_05, vertical: FontSizeUtil.SIZE_05),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 253, 253, 253),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _controllerMessage,
                      decoration: const InputDecoration(
                        hintText: Strings.ENTER_MESSAGE_TEXT,
                        hintStyle: TextStyle(color: Color(0xff1B5694)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      onChanged: (value) => {
                        setState(() {
                          enteredMessage = value;
                        })
                      },
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  if (_controllerMessage.text.isNotEmpty) {
                    if (_scrollController.hasClients) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 2),
                          curve: Curves.easeOut,
                        );
                      });
                    }
                    _sendChatMessageAndAddToList();
                  } else {
                    Utils.showToast(Strings.ISSUE_ACTION_ERROR_MESSAGE);
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: FontSizeUtil.CONTAINER_SIZE_30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final apartmentsId = prefs.getInt('apartmentId');

    print(apartmentsId);

    setState(() {
      senderId = id!;
      residentId = widget.residentId;
      apartmentId = apartmentsId!;
    });
    print("SenderId : $id");
    print("ReciverId : $residentId");

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "getMessage";
          int residentsId = widget.residentId;
          String ownerListUrl =
              '${Constant.getChatMessageURL}?senderId=$id&receiverId=$residentsId&apartId=$apartmentsId';

          NetworkUtils.getNetWorkCall(ownerListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _sendChatMessageAndAddToList() async {
    ChatMessageModel newMessage = ChatMessageModel(
      message: enteredMessage,
      senderId: senderId,
      receiverId: residentId,
      apartmentId: apartmentId,
    );
    setState(() {
      endToEndMessageLists.add(newMessage);
    });
    _controllerMessage.clear();
    _sendChatMessage();
  }

  _sendChatMessage() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "postMessage";
          var message = enteredMessage;
          String messageUrl =
              '${Constant.postChatMessageURL}?senderId=$senderId&receiverId=$residentId&content=$message&apartmentId=$apartmentId';
          NetworkUtils.postUrlNetWorkCall(messageUrl, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }
  //
  // _pushNotificationNetworkCall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final userName = prefs.getString(Strings.USERNAME);
  //
  //   Utils.getNetworkConnectedStatus().then((status) {
  //     Utils.printLog("network status : $status");
  //     setState(() {
  //       _isNetworkConnected = status;
  //       _isLoading = status;
  //       if (_isNetworkConnected) {
  //         _isLoading = true;
  //         var responseType = 'push';
  //         String keyName = '';
  //
  //         final Map<String, dynamic> bodyData = <String, dynamic>{
  //           "title": userName,
  //           "message": enteredMessage,
  //           "action": "Message"
  //         };
  //
  //         final Map<String, dynamic> data = <String, dynamic>{
  //           "to": widget.residentDeviseToken,
  //           "data": bodyData,
  //         };
  //         String partURL = Constant.pushNotificationURL;
  //         NetworkUtils.pushNotificationWorkCall(
  //             partURL, keyName, data, this, responseType);
  //       } else {
  //         Utils.printLog("else called");
  //         _isLoading = false;
  //         Utils.showCustomToast(context);
  //       }
  //     });
  //   });
  // }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() async {
        _isLoading = false;

        if (responseType == 'getMessage') {
          List<ChatMessageModel> movieList = (json.decode(response) as List)
              .map((item) => ChatMessageModel.fromJson(item))
              .toList();

          setState(() {
            endToEndMessageLists = movieList;
          });
        } else if (responseType == 'postMessage') {
          _choose();
          // _pushNotificationNetworkCall();
        } else {

        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
