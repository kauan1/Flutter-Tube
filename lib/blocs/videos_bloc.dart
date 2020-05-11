
import 'package:fluttertube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'dart:async';

class VideosBloc implements BlocBase{

  Api api;

  List<Video> videos;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>(); //saida do bloc
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();//entrada do bloc
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api= Api();

    _searchController.stream.listen(_search);//declarando os listeners do bloc
  }

  void _search(String search) async{
    if(search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search); //pedir para a api fazer a pesquisa
    }else{
      videos += await api.nextPage();//pedir para fazer a pesquisa dos proximos 10 videos
    }
    _videosController.sink.add(videos); //devolver a pesquisa feita
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

}