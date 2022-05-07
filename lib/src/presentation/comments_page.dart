import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/containers/comments_container.dart';
import 'package:movies/src/containers/selected_movie_container.dart';
import 'package:movies/src/containers/users_container.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Store<AppState> _store;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
      _store = StoreProvider.of<AppState>(context,listen: false);
      _store.dispatch(ListenForComments.start(_store.state.selectedMovieId!));
    // });
  }

  @override
  void dispose() {
    // _store = StoreProvider.of<AppState>(context);
    _store.dispatch(ListenForComments.done(_store.state.selectedMovieId!));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectedMovieContainer(
      builder: (BuildContext context, Movie movie) {
        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
          ),
          body: UsersContainer(
              builder: ((BuildContext context, Map<String, AppUser> users) {
            return CommentsContainer(
              builder: (BuildContext context, List<Comment> comments) {
                return SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                      height: 220,
                                      child: Image.network(movie.poster),
                                    ),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star),
                                        Text(
                                          movie.rating.toString(),
                                          style: TextStyle(fontSize: 30),),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 10,),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.56,
                                      height: 220,
                                      child: SingleChildScrollView(
                                        child: Text(movie.summary,style: TextStyle(fontSize: 15),),
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Comments:",
                              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),),
                          ),),
                        if (comments.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Comment comment = comments[index];
                                final AppUser user = users[comment.uid]!;

                                return ListTile(
                                  title: Text(comment.text),
                                  subtitle: Text(
                                    <Object>[user.username, comment.createdAt]
                                        .join('\n'),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          const Expanded(
                            child: Center(
                              child: Text("No comments yet!"),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                               labelText: 'Add a comment',
                              contentPadding: EdgeInsets.all(8),
                              suffix: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                ),
                                onPressed: () {
                                  if (_controller.text.isEmpty) return;
                                  StoreProvider.of<AppState>(context).dispatch(
                                      CreateComment.start(_controller.text));
                                  _controller.clear();
                                },
                              ),
                            ),
                          ),
                        ),
                      ]),
                );
              },
            );
          })),
        );
      },
    );
  }
}
