import 'package:age_calculator/age_calculator.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:peliculas/models/model.dart';
import 'package:peliculas/providers/movie_provider.dart';
import 'package:peliculas/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
            if (!snapshot.hasData) return const Loading();

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
          GestureDetector(
            onTap: () => _modal(context, cast.id.toString()),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(cast.fullProfilePath)),
            ),
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

  Future<dynamic> _modal(BuildContext context, String idActor) =>
      showCupertinoModalBottomSheet(
        builder: (BuildContext context) => _content(context, idActor),
        context: context,
        elevation: 1.0,
        isDismissible: false,
        bounce: true,
        barrierColor: Colors.black38,
      );

  Scaffold _content(BuildContext context, String idActor) {
    final MovieProvider movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: movieProvider.getActor(idActor),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Loading();
            final Actor data = snapshot.data as Actor;
            return Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 30,
                        left: 30,
                        top: 40,
                      ),
                      child: Row(
                        children: [
                          _imageModal(data.fullProfilePath),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: _name(data),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                _biography(data)
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _biography(Actor data) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15,
        left: 15,
        top: 20,
        bottom: 50,
      ),
      child: Text(
        data.biography!.isNotEmpty
            ? data.biography!
            : 'Biografía no disponible',
        style: const TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Column _name(Actor data) {
    List<String>? birthday =
        data.birthday != null ? data.birthday?.split('-') : [];
    String age = '';
    String dateBirthDay = '??/??/????';

    if (birthday!.isNotEmpty) {
      DateDuration duration = AgeCalculator.age(DateTime(
        int.parse(birthday[0]),
        int.parse(birthday[1]),
        int.parse(birthday[2]),
      ));
      age = '${duration.years} años';
      dateBirthDay = '${birthday[2]}/${birthday[1]}/${birthday[0]}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name,
          style: const TextStyle(
            fontSize: 30,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          dateBirthDay,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Text(age),
        Row(
          children: [
            const Icon(
              Icons.web_outlined,
              size: 15,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (data.homepage is String) {
                    _launchURL(data.homepage!);
                  }
                },
                child: Text(
                  data.homepage ?? 'No tiene pagína web',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  FadeInImage _imageModal(String img) {
    return FadeInImage(
      width: 100,
      height: 140,
      placeholder: const AssetImage('assets/no-image.jpg'),
      image: NetworkImage(img),
    );
  }

  Future<void> _launchURL(String urlString) async {
    if (!await launch(urlString)) throw 'Could not launch $urlString';
  }
}
