import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import './utils/firestore_helper.dart';

class MenuItens extends StatefulWidget {
  @override
  _MenuItensState createState() => _MenuItensState();
}

class _MenuItensState extends State<MenuItens> {
  final FirestoreHelper firestoreHelper = FirestoreHelper();

  int companyId;
  bool loading = true;
  List<Widget> companyList = [];

  @override
  void initState() {
    var companyData = firestoreHelper.getDocuments('company');

    companyData.listen((snapshot) {
      snapshot.documents.forEach((company) {
        companyList.add(
          CompanyCard(
            companyId: company['id'],
            imgURL: company['imgPath'],
            companyName: company['companyName'],
            companyArea: company['area'],
          ),
        );
      });

      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Selecione uma empresa para avaliar:'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: loading ? [] : companyList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  CompanyCard({
    this.companyId,
    this.imgURL,
    this.companyName,
    this.companyArea,
  });

  final int companyId;
  final String imgURL;
  final String companyName;
  final String companyArea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilEmpresa(
              companyId: companyId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 7, top: 10, right: 7, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 0.1,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  child: Image(
                    image: NetworkImage(imgURL),
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: companyName.length > 21 ? 60.0 : 30,
                      width: 250.0,
                      child: AutoSizeText(
                        companyName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue.shade900,
                        ),
                        maxLines: 2,
                        minFontSize: 24.0,
                      ),
                    ),
                    Text(
                      companyArea,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
