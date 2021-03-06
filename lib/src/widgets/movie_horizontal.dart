import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function sgtPagina;

  MovieHorizontal({@required this.peliculas, @required this.sgtPagina});

  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        sgtPagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.31,
      child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas.length,
          itemBuilder: (context, i) => _tarjeta(context, peliculas[i])),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula item) {
    item.uniqueId = '${item.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: item.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  height: 160.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(item.getPosterImg())),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            item.originalTitle,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle',arguments: item);
      },
      child: tarjeta,
    );
  }
}
