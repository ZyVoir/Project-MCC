class Pokemon {
  // atribut class pokemon
  String PokemonImage;
  String PokemonName;
  String PokemonTypePrimary;
  String PokemonTypeSecondary;
  int PokemonID;
  String PokemonDescription;
  int PokemonHeight_ft;
  int PokemonHeight_in;
  int PokemonWeight;
  double PokemonPrice;

  // normal constructor
  Pokemon({
    required this.PokemonImage,
    required this.PokemonName,
    required this.PokemonTypePrimary,
    required this.PokemonTypeSecondary,
    required this.PokemonID,
    required this.PokemonDescription,
    required this.PokemonHeight_ft,
    required this.PokemonHeight_in,
    required this.PokemonWeight,
    required this.PokemonPrice,
  });

  // constructor dari json
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      PokemonImage: json["PokemonImage_Link"].toString(),
      PokemonName: json["PokemonName"].toString(),
      PokemonTypePrimary: json["PokemonType_Primary"].toString(),
      PokemonTypeSecondary: json["PokemonType_Secondary"].toString(),
      PokemonID: json["PokemonID"] as int,
      PokemonDescription: json["PokemonDescription"].toString(),
      PokemonHeight_ft: json["PokemonHeight_ft"] as int,
      PokemonHeight_in: json["PokemonHeight_in"] as int,
      PokemonWeight: json["PokemonWeight_lbs"] as int,
      PokemonPrice: double.parse(
        json["PokemonPrice_Dollar"].toString(),
      ),
    );
  }
}
