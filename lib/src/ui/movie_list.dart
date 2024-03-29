import 'package:flutter/material.dart';
import 'package:flutter_bloc_app/src/blocs/movie_detail_bloc_provider.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';
import '../ui/movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    print('-->start bloc stream');
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    bloc.dispose();
    print('-->dispose bloc stream');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.results.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
              child: InkResponse(
                  enableFeedback: true,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
                    fit: BoxFit.cover,
                  ),
                  onTap: () => openDetailPage(snapshot.data, index),
              )
          );
        });
  }

  openDetailPage(ItemModel data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MovieDetailBlocProvider(
          child: MovieDetail(
            title: data.results[index].title,
            posterUrl: data.results[index].backdrop_path,
            description: data.results[index].overview,
            releaseDate: data.results[index].release_date,
            voteAverage: data.results[index].vote_average.toString(),
            movieId: data.results[index].id,
          ),
        );
      }),
    );
  }
}
