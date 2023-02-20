// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loja_flyinghigh/app/pesquisa/barra_pesquisa_view.dart';
import 'package:loja_flyinghigh/app/providers/campanhas_list.dart';
import 'package:loja_flyinghigh/app/providers/categorias_list.dart';
import 'package:loja_flyinghigh/app/providers/produtos_list.dart';
import 'package:provider/provider.dart';
import '../widgets/bottomSheet.dart';
import '../widgets/cardsRedeSocial.dart';
import '../widgets/colors.dart';

import 'package:flutter/material.dart';

//declara um objeto hc da classe controladora HomeState, para ser usada dentro da HomeView

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  bool isLoadingDestaques = true;
  bool isLoadingCategorias = true;
  bool isLoadingCampanhas = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProdutosList>(context, listen: false)
        .index()
        .then((value) => setState(() {
              isLoadingDestaques = false;
            }));
    Provider.of<CategoriasList>(context, listen: false)
        .index()
        .then((value) => setState(() {
              isLoadingCategorias = false;
            }));
    Provider.of<CampanhasList>(context, listen: false)
        .index()
        .then((value) => setState(() {
              isLoadingCampanhas = false;
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Cores cor = Cores();

  @override
  Widget build(BuildContext context) {
    final providerProdutos = Provider.of<ProdutosList>(context);
    //
    final providerCategorias = Provider.of<CategoriasList>(context);
    //
    final providerCampanhas = Provider.of<CampanhasList>(context);
    //
    final size = MediaQuery.of(context).size;

    //
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height >= 650
            ? MediaQuery.of(context).size.height / 13
            : MediaQuery.of(context).size.height / 11,
        leading: Container(
          child: GestureDetector(
            child: Icon(Icons.search, color: Colors.white),
            onTap: () {
              showSearch(
                context: context,
                delegate: Pesquisar(),
              );
            },
          ),
        ),
        actions: [
          Container(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/carrinho");
              },
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(cor.cCinza1),
                Color(cor.cCinza22),
                Color(cor.cCinza22),
                Color(cor.cCinza3),
              ],
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height / 11,
          child: Image.asset(
            'assets/logoamandaraupp.jpeg',
          ),
        ),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Cardsredesocial(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(),
                // height:MediaQuery.of(context).size.height / 3.6,
                // width: MediaQuery.of(context).size.width / 1,
                // decoration:  BoxDecoration(
                // border: Border.all(width: 2, color: Color(cor.corTransp)),
                //   color: Colors.white70,
                //     ),

                child: CarouselSlider(
                    options: CarouselOptions(
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        scrollDirection: Axis.horizontal,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        //enlargeStrategy: CenterPageEnlargeStrategy.height,
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        viewportFraction: 1),
                    items: isLoadingCampanhas ? [] : providerCampanhas.items),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 2.5, color: Colors.blueGrey.shade100),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7.2,
                child: isLoadingCategorias
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        margin: EdgeInsets.only(top: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: providerCategorias.items,
                          ),
                        ),
                      ),
              ),
              isLoadingDestaques
                  ? Container(
                      width: size.width,
                      height: size.height * 0.4,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container(
                      // margin: EdgeInsets.only( left: 2, right: 2),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceAround,
                        children: providerProdutos.cards,
                      ),
                    ),
              Container(
                  height: MediaQuery.of(context).size.height >= 800
                      ? MediaQuery.of(context).size.height / 14
                      : MediaQuery.of(context).size.height / 10),
            ],
          ),
        ),
      ),
    );
  }
}
