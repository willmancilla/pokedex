import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(         
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/':(context) => const PagInicial(),
        '/info':(context) => const Info(),
      },
      initialRoute: '/',
    );
  }
}

//================================= LISTA DE POKEMONS =====================================

class PagInicial extends StatefulWidget{
  const PagInicial({Key? key}) : super(key: key);

  @override
  State<PagInicial> createState() => _PagInicialState();
}

class _PagInicialState extends State<PagInicial>{
  List<Pokemon> listaPokemon = [];
  bool loading = true;

  @override
  void initState(){
    _getPokemon();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 200),
              child: const Text('Pokedex'),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(
                'https://raw.githubusercontent.com/RafaelBarbosatec/SimplePokedex/master/assets/pokebola_img.png',
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: listaPokemon.length,
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: ListTile(
                    title: Text(listaPokemon[index].name ?? ''),
                    onTap: (){
                      Navigator.of(context).pushNamed('/info', arguments: listaPokemon[index]);
                    },
                    leading: Image.network(listaPokemon[index].thumbnailImage ?? ''),
                    trailing: Text('#${listaPokemon[index].number ?? ''}',
                    style: const TextStyle(color: Color.fromARGB(255, 68, 68, 68)),
                    ),
                  ),
                ),
              );
            }
          ),
          if (loading) const Center(child: CircularProgressIndicator(),),
        ],
      ),
    );
  }

//=============================== CHAMADA DA API ====================================

  void _getPokemon(){
  var url = Uri.parse('http://104.131.18.84/pokemon/?limit=50&page=0');

  setState((){
    loading = true;
  });

  http.get(url).then((value){
    if(value.statusCode == 200){
      setState((){
        Map json = const JsonDecoder().convert(value.body);

      for(var element in (json['data'] as List)){
        listaPokemon.add(Pokemon.fromJson(element));
      }

       loading = false;
      });
    }
  });
 }
}

//================================== INFORMAÇÕES DO POKEMON =============================

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pokemon info = ModalRoute.of(context)!.settings.arguments as Pokemon;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${info.name}'),
      ),
      body: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 122),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(17)),
                        color: Color.fromARGB(108, 214, 214, 209),
                      ),
                      width: double.infinity,
                      child: Image.network(info.thumbnailImage ?? ''),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: Text('#${info.number}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${info.description}',
                textAlign: TextAlign.left,
              ),
              const Divider(
                height: 25,
                thickness: 1,
              ),
              const Text(
                'Tipo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(info.type!.join(' / ')),
              const Divider(
                height: 25,
                thickness: 1,
              ),
              const Text(
                'Fraquezas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(info.weakness!.join(' / ')),
            ],
          ),
        ),
      ),
    );
  }
}

//========================== CLASSE POKEMON =============================

class Pokemon{
    List<String>? abilities;
    String? detailPageUrl;
    int? weight;
    List<String>? weakness;
    String? number;
    int? height;
    String? collectiblesSlug;
    String? featured;
    String? slug;
    String? description;
    String? name;
    String? thumbnailAltText;
    String? thumbnailImage;
    int? id;
    List<String>? type;

    Pokemon(
      {this.abilities, 
      this.detailPageUrl, 
      this.weight, 
      this.weakness, 
      this.number, 
      this.height, 
      this.collectiblesSlug, 
      this.featured, 
      this.slug, 
      this.description, 
      this.name, 
      this.thumbnailAltText, 
      this.thumbnailImage, 
      this.id, 
      this.type});

    Pokemon.fromJson(Map<String, dynamic> json) {
        abilities = json["abilities"]==null ? null : List<String>.from(json["abilities"]);
        detailPageUrl = json["detailPageURL"];
        weight = json["weight"];
        weakness = json["weakness"]==null ? null : List<String>.from(json["weakness"]);
        number = json["number"];
        height = json["height"];
        collectiblesSlug = json["collectibles_slug"];
        featured = json["featured"];
        slug = json["slug"];
        description = json["description"];
        name = json["name"];
        thumbnailAltText = json["thumbnailAltText"];
        thumbnailImage = json["thumbnailImage"];
        id = json["id"];
        type = json["type"]==null ? null : List<String>.from(json["type"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        if(abilities != null) {
          data["abilities"] = abilities;
        }
        data["detailPageURL"] = detailPageUrl;
        data["weight"] = weight;
        if(weakness != null) {
          data["weakness"] = weakness;
        }
        data["number"] = number;
        data["height"] = height;
        data["collectibles_slug"] = collectiblesSlug;
        data["featured"] = featured;
        data["slug"] = slug;
        data["description"] = description;
        data["name"] = name;
        data["thumbnailAltText"] = thumbnailAltText;
        data["thumbnailImage"] = thumbnailImage;
        data["id"] = id;
        if(type != null) {
          data["type"] = type;
        }
        return data;
  }
}