import 'package:flutter/cupertino.dart';
import 'package:peliculas/models/model.dart';

class CastingCards extends StatelessWidget {
  final String title;
  final Future<List<Person>> getData;

  const CastingCards({
    Key? key,
    required this.title,
    required this.getData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 10,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ),
        FutureBuilder(
          future: getData,
          builder: (context, AsyncSnapshot<List<Person>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                constraints: const BoxConstraints(maxHeight: 150),
                height: 180,
                child: const CupertinoActivityIndicator(),
              );
            }

            final List<Person> cast = snapshot.data!;

            return Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.only(bottom: 30),
              child: ListView.builder(
                itemCount: cast.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) => _CastCard(
                  cast: cast[index],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  final Person cast;

  const _CastCard({
    Key? key,
    required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(cast.fullProfilePath)),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
