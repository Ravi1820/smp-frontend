import 'dart:async';
import 'dart:convert';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/block_model.dart';
import 'package:SMP/model/flat_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockSelectionScreen extends StatefulWidget {
  const BlockSelectionScreen({super.key});

  @override
  State<BlockSelectionScreen> createState() {
    return _BlockSelectionScreenState();
  }
}

class _BlockSelectionScreenState extends State<BlockSelectionScreen>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String apartmentName = '';
  List blocklist = [];
  List flatlist = [];
  List globalResidentList = [];
  List selectedBlock = [];
  bool showCheckbox = false;
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = false;
  String query = "";
  int apartmentId = 0;
  int residentId = 0;
  String baseImageIssueApi = '';
  bool showErrorMessage = false;
  bool showPurposeErrorMessage = false;
  Color _containerBorderColor1 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  List<int> ownerIds = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _choose();
    init();
    _updateOwnerName();
  }

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentId = apartId!;
      apartmentName = apartName!;
      residentId = id!;
    });
  }

  Future<void> getList() async {
    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(residentId, "profile");
    });
  }

  void _updateOwnerName() async {
    List<String> blockIds =
        selectedCountries.map((block) => block.id.toString()).toList();
    print("Selected Block $blockIds");

    // Iterate over each selected block
    for (var blockId in blockIds) {
      // Find flats corresponding to the current block
      List filteredBlocks = flatlist
          .where((floor) => floor.blockId.toString() == blockId)
          .toList();

      // Extract resident IDs from owner and tenant of each flat
      for (var block in filteredBlocks) {
        setState(() {
          if (block.owner != null && block.owner!.id != null) {
            ownerIds.add(block.owner!.id); // Append owner ID to the list
          }
          if (block.tenant != null && block.tenant!.id != null) {
            ownerIds.add(block.tenant!.id); // Append tenant ID to the list
          }
        });
      }
    }

    print("Resisdent IdownerIds $ownerIds");
    setState(() {
      selectedBlock = ownerIds;
    });
  }

  _getFlatList(blockId) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        // _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "flatList";
          String flatListURL =
              '${Constant.flatListURL}?apartmentId=$apartmentId&blockId=$blockId';
          NetworkUtils.getNetWorkCall(flatListURL, responseType, this)
              .then((response) {
            // Call _updateOwnerName() only after the network call completes
            // _updateOwnerName();
          });
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmentId1 = prefs.getInt('apartmentId');

    setState(() {
      apartmentId = apartmentId1!;
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "blockList";
          String blockListUrl =
              '${Constant.blockListURL}?apartmentId=$apartmentId';
          NetworkUtils.getNetWorkCall(blockListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void editUserChoice(users) {
    _formKey.currentState!.save();
  }

  @override
  void dispose() {
    _searchController.dispose();
    globalResidentList = [];
    super.dispose();
  }

  bool showSecurtiy = true;
  List<BlockModel> selectedCountries = [];

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (globalResidentList.isEmpty && query.isNotEmpty) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: Text(
            Strings.NO_RESIDNT_AVAILABLE,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1B5694),
            ),
          ),
        ),
      );
    } else {
      content = ListView(
        children: blocklist.map((block) {
          final isSelected = selectedCountries.contains(block);
          return Column(
            children: <Widget>[
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    selectedCountries.add(block);
                  });
                  _getFlatList(block.id);
                },
                onTap: () {
                  setState(() {
                    if (selectedCountries.contains(block)) {
                      selectedCountries.remove(block);
                    } else {
                      selectedCountries.add(block);
                    }
                  });
                  _getFlatList(block.id);
                },
                child: Card(
                  child: Container(
                    decoration: isSelected
                        ? BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(179, 179, 179, 1),
                                Color.fromRGBO(175, 175, 175, 1),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(FontSizeUtil.SIZE_10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(1, 4),
                              ),
                            ],
                          )
                        : AppStyles.decoration(context),
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  block.blockName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff1B5694)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Residents of $apartmentName",
          profile: () {},
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
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
                child: Column(
                  children: <Widget>[
                    SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                    Expanded(child: content),
                    SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                    const FooterScreen(),
                  ],
                ),
              ),
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: FontSizeUtil.CONTAINER_SIZE_100,
            left: FontSizeUtil.CONTAINER_SIZE_50),
        child: FloatingActionButton(
          onPressed: () {
            if (selectedCountries.isNotEmpty) {
              _showCustomDialog(
                  context, _containerBorderColor1, _boxShadowColor1);
            } else {
              Fluttertoast.showToast(
                msg: Strings.SELECT_ANY_BLOCK_TEXT,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          backgroundColor: const Color(0xff1B5694),
          foregroundColor: Colors.white,
          child: const Icon(Icons.message_sharp),
        ),
      ),
    );
  }

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
      setState(() {
        if (responseType == 'blockList') {
          _isLoading = false;

          List<BlockModel> blocklst = (json.decode(response) as List)
              .map((item) => BlockModel.fromJson(item))
              .toList();

          blocklist = blocklst;
        } else if (responseType == 'flatList') {
          _isLoading = false;

          List<FlatModel> blocklst = (json.decode(response) as List)
              .map((item) => FlatModel.fromJson(item))
              .toList();
          // _updateOwnerName();

          flatlist = blocklst;
          _updateOwnerName();
        } else if (responseType == 'postMessage') {
          _isLoading = false;
          successDialogWithListner(
              context, response, const BlockSelectionScreen(), this);
        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  void _showCustomDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(FontSizeUtil.SIZE_01),
          content: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: 330,
              decoration: AppStyles.decoration(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: FontSizeUtil.CONTAINER_SIZE_30),
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  color: const Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: Container(
                              height: FontSizeUtil.CONTAINER_SIZE_30,
                              width: FontSizeUtil.CONTAINER_SIZE_30,
                              decoration: AppStyles.circle1(context),
                              child: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.CONTAINER_SIZE_18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              FocusScope(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      containerBorderColor1 = hasFocus
                                          ? const Color.fromARGB(
                                              255, 0, 137, 250)
                                          : Colors.white;
                                      boxShadowColor = hasFocus
                                          ? const Color.fromARGB(
                                              162, 63, 158, 235)
                                          : const Color.fromARGB(
                                              255, 100, 100, 100);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: boxShadowColor,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: containerBorderColor1,
                                      ),
                                    ),
                                    height: FontSizeUtil.CONTAINER_SIZE_100,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top:
                                                FontSizeUtil.CONTAINER_SIZE_14),
                                        prefixIcon: const Icon(
                                          Icons.description,
                                          color: Color(0xff4d004d),
                                        ),
                                        hintText: Strings.ENTER_MESSAGE_TEXT,
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length > 20) {
                                          setState(() {
                                            // showErrorMessage = true;
                                          });
                                        } else {
                                          setState(() {});
                                          return null;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newOption = value;
                                      },
                                      onSaved: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_40,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_20),
                                      side: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 0, 123, 255),
                                          width: FontSizeUtil.SIZE_02),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_15,
                                        vertical: FontSizeUtil.SIZE_05),
                                  ),
                                  onPressed: () {
                                    String trimmedOption = newOption.trim();

                                    if (trimmedOption.isNotEmpty) {
                                      String result = selectedBlock
                                          .toString(); // Convert the list to a string
                                      result = result.substring(
                                          1, result.length - 1);
                                      print(result);

                                      print(result);
                                      Utils.getNetworkConnectedStatus()
                                          .then((status) {
                                        setState(() {
                                          _isNetworkConnected = status;
                                          _isLoading = status;

                                          if (_isNetworkConnected) {
                                            String responseType = "postMessage";

                                            var message = trimmedOption;

                                            String messageUrl =
                                                '${Constant.postChatMessageURL}?senderId=$residentId&receiverId=$result&content=$message&apartmentId=$apartmentId';

                                            NetworkUtils.postUrlNetWorkCall(
                                                messageUrl, this, responseType);
                                          } else {
                                            Utils.printLog("else called");
                                            _isLoading = false;
                                            Utils.showCustomToast(context);
                                          }
                                        });
                                      });
                                      Navigator.of(context).pop();
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: Strings.ENTER_MESSAGE_ERROR_TEXT,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_16,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.send),
                                      SizedBox(
                                          width:
                                              FontSizeUtil.CONTAINER_SIZE_10),
                                      const Text(
                                        Strings.MESSAGE_SEND_TEXT,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
  }
}
