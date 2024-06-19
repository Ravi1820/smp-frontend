import 'package:SMP/view_model/owner_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OwnerGridViewCard extends StatelessWidget {
  final Function press;
  final List users;

  const OwnerGridViewCard({Key? key, required this.users, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: const Color(0xff1B5694),
    );

    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1.0,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF82D9FF),
                            Color.fromARGB(172, 186, 227, 243),
                            Color(0xFF82D9FF),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 15,
                            margin: const EdgeInsets.only(left: 10),
                            shadowColor: Colors.amber,
                            child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                    width: 1.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  child: Image.memory(
                                    user.residentImages as Uint8List,
                                    fit: BoxFit.fitWidth,
                                    width: 100,
                                    height: 100,
                                  ),
                                )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? "",
                                  style:headerPlaceHolder ,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user.emailId ?? "",
                                  style: headerLeftTitle,
                                ),
                                 Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.mobile ?? "",
                                      style: headerLeftTitle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: GestureDetector(
                                        onTap: () => press(user),
                                        // _showDetailsDialog(
                                        //   context,
                                        //   user,
                                        //   press,
                                        //   headerLeftTitle,
                                        //   headerPlaceHolder,
                                        // ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Text(
                                              'View Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showDetailsDialog(
    BuildContext context,
      user,
    Function press,
    TextStyle headerLeftTitle,
    TextStyle headerPlaceHolder,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            width: 350,
            height: 400,
            child: SingleChildScrollView(
              child:
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTableRow(
                    "Full Name",
                    user.userName ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Age",
                    user.age ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Email Id",
                    user.emailId ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Mobile",
                    user.mobile ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Gender",
                    user.gender ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Flat No",
                    user.flatNumber ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Block No",
                    user.blockNumber ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                  _buildTableRow(
                    "Address",
                    user.address ?? "",
                    headerLeftTitle,
                    headerPlaceHolder,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 123, 255), width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    onPressed: () {
                      press(user);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 123, 255), width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableRow(
    String leftText,
    String rightText,
    TextStyle headerLeftTitle,
    TextStyle headerPlaceHolder,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(leftText, style: headerLeftTitle),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              rightText,
              style: headerPlaceHolder,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
