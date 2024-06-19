import 'package:SMP/view_model/apartment_global_search.dart';
import 'package:flutter/material.dart';

class ApartmentGridViewCard extends StatelessWidget {
  final Function(ApartmentGlobalSearchViewModel) press;

  final List<ApartmentGlobalSearchViewModel> users;

  const ApartmentGridViewCard(
      {super.key, required this.users, required this.press});

  @override
  Widget build(BuildContext context) {
    const TextStyle headerTitle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: Color(0xff1B5694));

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.2, // Adjust this aspect ratio for more height

      children: List.generate(
        users.length,
        (index) {
          return Builder(builder: (context) {
            final movie = users[index];

            return GestureDetector(
              onTap: () => press(movie),
              child: Card(
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF82D9FF), // Start color
                        Color.fromARGB(172, 186, 227, 243), // End color
                        Color(0xFF82D9FF), // Start color
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(movie.flatName, style: headerTitle),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
