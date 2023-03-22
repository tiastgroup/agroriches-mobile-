import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/popular_articles_bloc.dart';
import 'package:news_app/cards/card2.dart';
import 'package:news_app/cards/card4.dart';
import 'package:news_app/cards/card5.dart';
import 'package:provider/provider.dart';

class PopularArticles extends StatefulWidget {
  PopularArticles({Key? key}) : super(key: key);

  @override
  _PopularArticleState createState() => _PopularArticleState();
}

class _PopularArticleState extends State<PopularArticles> {
  @override
  Widget build(BuildContext context) {
    final pb = context.watch<PopularBloc>();

    return Column(
      children: <Widget>[
        Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 15, bottom: 10, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 22,
                  width: 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  width: 6,
                ),
                Text('popular news',
                        style: TextStyle(
                            fontSize: 18,
                            letterSpacing: -0.6,
                            wordSpacing: 1,
                            fontWeight: FontWeight.bold))
                    .tr(),
              ],
            )),
        ListView.separated(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          physics: NeverScrollableScrollPhysics(),
          itemCount: pb.data.length != 0 ? pb.data.length + 1 : 1,
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: 15,
          ),
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            if (index < pb.data.length) {
              if (index % 3 == 0 && index != 0)
                return Card5(d: pb.data[index], heroTag: 'popular$index');
              if (index % 5 == 0 && index != 0)
                return Card4(d: pb.data[index], heroTag: 'popular$index');
              else
                return Card2(
                  d: pb.data[index],
                  heroTag: 'popular$index',
                );
            }
            // return Opacity(
            //   opacity: rb.isLoading ? 1.0 : 0.0,
            //   child: Center(
            //     child: SizedBox(
            //         width: 32.0,
            //         height: 32.0,
            //         child: new CupertinoActivityIndicator()),
            //   ),
            // );
          },
        )
      ],
    );
  }
}
