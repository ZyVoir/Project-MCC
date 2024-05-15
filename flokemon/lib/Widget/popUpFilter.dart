import 'package:flutter/material.dart';

class popUpFilter extends StatefulWidget {
  final Function(int) filterByHandler;
  final Function(int) typeGetter;
  final int filterIndexGet;
  final int filterTypeGet;
  const popUpFilter({
    super.key,
    required this.filterByHandler,
    required this.filterIndexGet,
    required this.typeGetter,
    required this.filterTypeGet,
  });

  @override
  State<popUpFilter> createState() => _popUpFilterState();
}

class _popUpFilterState extends State<popUpFilter> {
  List<bool> filterByEnabled = List.filled(6, false);
  int filterByEnabledIndex = -1;
  Color filterByColorON = const Color.fromARGB(255, 112, 208, 116);

  List<bool> typeEnabled = List.filled(18, false);
  int typeIndex = -1;

  Color typeMapColor(int typeIdx) {
    switch (typeIdx) {
      case 0:
        return const Color.fromARGB(255, 18, 94, 178);
      case 1:
        return const Color.fromARGB(255, 190, 25, 0);
      case 2:
        return const Color.fromARGB(255, 81, 155, 18);
      case 3:
        return const Color.fromARGB(255, 95, 249, 249);
      case 4:
        return const Color.fromARGB(255, 237, 230, 58);
      case 5:
        return const Color.fromARGB(255, 67, 80, 197);
      case 6:
        return const Color.fromARGB(255, 64, 51, 7);
      case 7:
        return const Color.fromARGB(255, 185, 56, 246);
      case 8:
        return const Color.fromARGB(255, 137, 151, 14);
      case 9:
        return const Color.fromARGB(255, 167, 128, 26);
      case 10:
        return const Color.fromARGB(255, 158, 134, 61);
      case 11:
        return const Color.fromARGB(255, 125, 125, 125);
      case 12:
        return const Color.fromARGB(255, 39, 41, 94);
      case 13:
        return const Color.fromARGB(255, 211, 49, 107);
      case 14:
        return const Color.fromARGB(255, 207, 191, 158);
      case 15:
        return const Color.fromARGB(255, 25, 121, 162);
      case 16:
        return const Color.fromARGB(255, 64, 51, 7);
      case 17:
        return const Color.fromARGB(255, 235, 126, 211);
    }
    return Colors.black;
  }

  Color defaultOFF = Color.fromARGB(255, 219, 219, 219);
  double FontSize = 11;

  @override
  void initState() {
    setState(() {
      filterByEnabledIndex = widget.filterIndexGet;
      if (filterByEnabledIndex != -1) filterByEnabled[filterByEnabledIndex] = true;
      typeIndex = widget.filterTypeGet;
      if (typeIndex != -1) typeEnabled[typeIndex] = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 420,
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "Sort By :",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[0] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[0] = !filterByEnabled[0];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[0] = true;
                          filterByEnabledIndex = 0;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "A to Z",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[0] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[0] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[1] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[1] = !filterByEnabled[1];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[1] = true;
                          filterByEnabledIndex = 1;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "Highest\nPrice",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[1] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[1] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[2] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[2] = !filterByEnabled[2];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[2] = true;
                          filterByEnabledIndex = 2;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "Highest\nIndex",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[2] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[2] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[3] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[3] = !filterByEnabled[3];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[3] = true;
                          filterByEnabledIndex = 3;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "Z to A",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[3] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[3] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[4] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[4] = !filterByEnabled[4];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[4] = true;
                          filterByEnabledIndex = 4;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "Lowest\nPrice",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[4] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[4] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (filterByEnabled[5] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          filterByEnabled[5] = !filterByEnabled[5];
                          // reset index jd gk di pegang sp sp
                          filterByEnabledIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (filterByEnabledIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            filterByEnabled[filterByEnabledIndex] = false;
                          }
                          // nyalain tombol + set index;
                          filterByEnabled[5] = true;
                          filterByEnabledIndex = 5;
                        }
                        widget.filterByHandler(filterByEnabledIndex);
                      });
                    },
                    child: Text(
                      "Lowest\nIndex",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: filterByEnabled[5] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filterByEnabled[5] == false ? defaultOFF : filterByColorON,
                      elevation: 0,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: const [
                  Text(
                    "Type :",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // type row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[0] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[0] = !typeEnabled[0];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[0] = true;
                          typeIndex = 0;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "WATER",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[0] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[0] == false ? defaultOFF : typeMapColor(0),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[1] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[1] = !typeEnabled[1];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[1] = true;
                          typeIndex = 1;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "FIRE",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[1] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[1] == false ? defaultOFF : typeMapColor(1),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[2] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[2] = !typeEnabled[2];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[2] = true;
                          typeIndex = 2;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "GRASS",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[2] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[2] == false ? defaultOFF : typeMapColor(2),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[3] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[3] = !typeEnabled[3];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[3] = true;
                          typeIndex = 3;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "ICE",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[3] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[3] == false ? defaultOFF : typeMapColor(3),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              // type row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[4] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[4] = !typeEnabled[4];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[4] = true;
                          typeIndex = 4;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "ELECTRIC",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[4] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[4] == false ? defaultOFF : typeMapColor(4),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[5] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[5] = !typeEnabled[5];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[5] = true;
                          typeIndex = 5;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "DRAGON",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[5] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[5] == false ? defaultOFF : typeMapColor(5),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[6] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[6] = !typeEnabled[6];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[6] = true;
                          typeIndex = 6;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "FIGHTING",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[6] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[6] == false ? defaultOFF : typeMapColor(6),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[7] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[7] = !typeEnabled[7];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[7] = true;
                          typeIndex = 7;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "POISON",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[7] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[7] == false ? defaultOFF : typeMapColor(7),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              // type row 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[8] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[8] = !typeEnabled[8];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[8] = true;
                          typeIndex = 8;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "BUG",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[8] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[8] == false ? defaultOFF : typeMapColor(8),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[9] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[9] = !typeEnabled[9];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[9] = true;
                          typeIndex = 9;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "GROUND",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[9] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[9] == false ? defaultOFF : typeMapColor(9),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[10] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[10] = !typeEnabled[10];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[10] = true;
                          typeIndex = 10;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "ROCK",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[10] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[10] == false ? defaultOFF : typeMapColor(10),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[11] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[11] = !typeEnabled[11];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[11] = true;
                          typeIndex = 11;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "STEEL",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[11] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[11] == false ? defaultOFF : typeMapColor(11),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              // type row 4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[12] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[12] = !typeEnabled[12];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[12] = true;
                          typeIndex = 12;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "GHOST",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[12] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[12] == false ? defaultOFF : typeMapColor(12),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[13] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[13] = !typeEnabled[13];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[13] = true;
                          typeIndex = 13;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "PSYCHIC",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[13] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[13] == false ? defaultOFF : typeMapColor(13),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[14] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[14] = !typeEnabled[14];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[14] = true;
                          typeIndex = 14;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "NORMAL",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[14] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[14] == false ? defaultOFF : typeMapColor(14),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[15] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[15] = !typeEnabled[15];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[15] = true;
                          typeIndex = 15;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "FLYING",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[15] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[15] == false ? defaultOFF : typeMapColor(15),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              // type row 5
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[16] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[16] = !typeEnabled[16];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[16] = true;
                          typeIndex = 16;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "DARK",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[16] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[16] == false ? defaultOFF : typeMapColor(16),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (typeEnabled[17] == true) {
                          // kalau lg on trus di matiin
                          // reset button nya
                          typeEnabled[17] = !typeEnabled[17];
                          // reset index jd gk di pegang sp sp
                          typeIndex = -1;
                        } else {
                          // kalau posisi nya off mau di nyalain
                          if (typeIndex != -1) {
                            // kalau ad yg di on di tmbl lain
                            // off in dlu tombol lainnya
                            typeEnabled[typeIndex] = false;
                          }
                          // nyalain tombol + set index;
                          typeEnabled[17] = true;
                          typeIndex = 17;
                        }
                        widget.typeGetter(typeIndex);
                      });
                    },
                    child: Text(
                      "FAIRY",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSize,
                        color: typeEnabled[17] == false ? Colors.black : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeEnabled[17] == false ? defaultOFF : typeMapColor(17),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
