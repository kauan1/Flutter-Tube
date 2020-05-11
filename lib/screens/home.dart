import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widget/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<VideosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 75,
          child: Image.asset("images/youtube.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.of<FavoriteBloc>(context).outFav,
                builder:(context,snapshot){
                  if(snapshot.hasData) return Text("${snapshot.data.length}");
                  else return Container();
                }
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>Favorites())
              );
            },
          ),
          IconButton (
            icon: Icon(Icons.search),
            onPressed: () async{
              String result = await showSearch(context: context, delegate: DataSearch());
              if(result!= null) bloc.inSearch.
              add(result);//add no bloc oque eu quero pesquisar
              },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(//não terá dado a hora que abrir o app
          initialData: [],//inicializar com uma lista vazia
          stream: bloc.outVideos,
          builder: (context, snapshot){
            if(snapshot.hasData)
              return ListView.builder(
                  itemBuilder: (context, index){
                    if(index<snapshot.data.length) {
                      return VideoTile(snapshot.data[index]);
                    }else if(index>1){//espera enquanto carrega mais, e verifica
                      // se ja chegou ao fim ou pesquisou alguma coisa pq sem
                      // ele o app vai tentar ficar carregando uma coisa que ele
                      // ainda não pesquisou por causa do +1(quando não tiver pesquisado nada)
                      bloc.inSearch.add(null);//pede mais 10 videos para ser carregados
                      return Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    }else{
                      return Container();
                    }
                  },
                itemCount: snapshot.data.length+1,//esse 1 a mais é pra fazer que quando chegue no ultimo espere ate carrgar mais
              );
            else
              return Container();
          }
      ),
    );
  }
}
