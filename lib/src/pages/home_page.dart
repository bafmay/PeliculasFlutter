import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swipper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  
  final provider = PeliculaProvider();

  @override
  Widget build(BuildContext context) {

      provider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: (){
              showSearch(
                context: context, 
                delegate: DataSearch(),
                query: ''
              );
            }
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swipeTarjetas(),
            _footer(context)
          ],
        ),
      )
    );
  }

  Widget _swipeTarjetas() {
    return FutureBuilder(
      future: provider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return CardSwipper(peliculas: snapshot.data); 
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
        
      },
    );
    
    
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1)
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: provider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  sgtPagina: provider.getPopulares,
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      )
    );
  }

}