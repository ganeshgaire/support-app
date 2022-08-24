import 'package:flutter/material.dart';

import '../model/allinformationmodel.dart';

class ProblemSearchPage extends StatefulWidget {
  List<ProblemCategories> data;
  final Function(String, String) callback;
  // dynamic selectedProblemcategories;
  // TextEditingController problemcategoriesController = TextEditingController();
  ProblemSearchPage({Key? key, required this.data, required this.callback})
      : super(key: key);

  @override
  State<ProblemSearchPage> createState() => _ProblemSearchPageState();
}

class _ProblemSearchPageState extends State<ProblemSearchPage> {
  TextEditingController problemcontroller = TextEditingController();
  List<ProblemCategories> searchlist = [];
  void changeFuction(query) {
    final myList = query.isEmpty
        ? widget.data
        : widget.data
            .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
    setState(() {
      searchlist = myList;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      searchlist = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 95),
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: problemcontroller,
                  onChanged: (value) {
                    changeFuction(value);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(
                              255,
                              212,
                              221,
                              227,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            changeFuction('');
                            problemcontroller.clear();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Search Problems'),
                ),
              ),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: searchlist.length,
                    separatorBuilder: (context, int int) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      final _items = searchlist[index];
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _items.name.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        onTap: () {
                          widget.callback(
                              _items.name.toString(), _items.id.toString());
                          Navigator.pop(context);
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
