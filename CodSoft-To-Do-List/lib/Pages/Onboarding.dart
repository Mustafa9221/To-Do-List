import 'package:flutter/material.dart';
import './data.dart';

class Data {
  String img_path;
  String title;
  String description;
  Data(this.img_path, this.title, this.description);
}

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  // ignore: non_constant_identifier_names
  List<Data> PageData = [
    Data("assets/Listoftask.png", "Welcome",
        "Welcome to To Do List App where you can add Tasks along with its due date and priority also user can edit their task tittle and description along with that user can set their task as completed or active further more user can delete their task"),
    Data("assets/edit.png", "Edit",
        "Edit your Task tittle and description by simply clicking on the edit Icon and you can edit your tittle and description of your task"),
    Data("assets/delete.png", "Complete and Delete",
        "Users are allowed to delete their tasks whenever they want buy simply slide the task a delete Icon will popup and by clicking the delete Icon the Task will be deleted from the List of Task")
  ];
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 3,
        onPageChanged: (value) {
          currentpage = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          currentpage = index;
          return Page(PageData[index]);
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3 && currentpage != 2; i++)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 10,
                      width: i == currentpage ? 30 : 10,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            if (currentpage == 2)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.amber,
                    child: TextButton(
                      onPressed: () {
                        sp.setInt("onboard", 2);
                        Navigator.pushNamed(context, "Home");
                      },
                      child: const Text(
                        "GET STARTED",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Page extends StatelessWidget {
  Data data;
  Page(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(data.img_path),
        const SizedBox(
          height: 20,
        ),
        Text(
          data.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
