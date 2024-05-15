import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: TextField(
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(15),
                    width: 50,
                    child: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ),
          ],
        )
      ],
    );
  }
}
