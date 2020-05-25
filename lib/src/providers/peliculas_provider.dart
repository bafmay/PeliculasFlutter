import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculaProvider{

  String _apikey = '8c1a85913c33ed87a4dbc391d815da58';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStream(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apikey,
      'language': _language
    });

    return await _getPeliculas(url);
  }

  Future<List<Pelicula>> _getPeliculas(Uri url) async{
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    
    final peliculas = Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {

    if(_cargando) return [];
    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',{
      'api_key' : _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final rpta =  await _getPeliculas(url);

    _populares.addAll(rpta);
    popularesSink(_populares);
    _cargando = false;
    return rpta;
  }

  Future<List<Actor>> getCast(String peliculaId) async{
    final url = Uri.https(_url, '3/movie/$peliculaId/credits',{
      'api_key' : _apikey,
      'language': _language
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',{
      'api_key' : _apikey,
      'language': _language,
      'query'   : query
    });

    return await _getPeliculas(url);
  }

}