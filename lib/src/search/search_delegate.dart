import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  
  final provider = PeliculaProvider();
  String seleccion = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izq del appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Las sugerencias que aparecen cuando se escribe
    if(query.isEmpty){
      return Container();
    }else{
      return FutureBuilder(
        future: provider.buscarPelicula(query),
        builder: (context,AsyncSnapshot<List<Pelicula>> snapshot){
          if(snapshot.hasData){
            final peliculas = snapshot.data;
            return ListView.builder(
              itemCount: peliculas.length,
              itemBuilder: (context,i){
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage(peliculas[i].getPosterImg()),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(peliculas[i].title),
                  subtitle: Text(peliculas[i].originalTitle),
                  onTap: (){
                    close(context, null);
                    peliculas[i].uniqueId = '';
                    Navigator.pushNamed(context, 'detalle',arguments: peliculas[i]);
                  },
                );
              }
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
    }
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   //Las sugerencias que aparecen cuando se escribe
  //   final listaSugerida = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas
  //           .where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

  //   return ListView.builder(
  //       itemCount: listaSugerida.length,
  //       itemBuilder: (context, i) {
  //         return ListTile(
  //           leading: Icon(Icons.movie),
  //           title: Text(listaSugerida[i]),
  //           onTap: () {
  //             seleccion = listaSugerida[i];
  //             showResults(context);
  //           },
  //         );
  //       });
  // }
}
