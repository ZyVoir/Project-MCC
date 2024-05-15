import 'package:flokemon/Widget/button2.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  // nerima data list transaction untuk di show
  final Future<List<Map<String, dynamic>>> transactionList;
  const History({
    super.key,
    required this.transactionList,
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1D84DB), Color.fromRGBO(29, 60, 221, 1), Color(0xFF1D84DB)]),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 90,
              right: 0.5,
              child: Transform.rotate(
                angle: 2.55,
                child: const Opacity(
                  opacity: 0.15,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 122,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("Asset/HOME OFF.png"),
                      radius: 120,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 560,
              left: 0.5,
              child: Transform.rotate(
                angle: 0.50,
                child: const Opacity(
                  opacity: 0.15,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 122,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("Asset/HOME OFF.png"),
                      radius: 120,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                      child: Row(
                        children: const [
                          Button2(),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            "HISTORY",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(147, 0, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          height: 4,
                          width: 128,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FutureBuilder(
                      // future builder listview card buat nunjukkin transaksi user
                      future: widget.transactionList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // jika masih loading, tunjukin loading circular indicator
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              color: Colors.red,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // jika error dalam pengambilan data
                          return Text('Error: ${snapshot.error}');
                        }
                        // jika future sudah tersedia
                        var data = snapshot.data as List<Map<String, dynamic>>;
                        data = data.reversed.toList();
                        // jika data transaksi tidak ada
                        if (data.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "You haven't bought any pokemon",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Consider buying one !",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        }
                        // jika data transaksi ada, tunjukkin
                        return ListView(
                          children: data
                              .map(
                                (e) => Card(
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    leading: Image.network(
                                      e['PokemonImage_Link'],
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset("Asset/Logo2.png");
                                      },
                                    ),
                                    title: Text(
                                      e["PokemonName"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text("Amount : ${e["OwnedPokemon"]}"),
                                    trailing: Text(
                                      "\$${e["TotalSpend"]}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
