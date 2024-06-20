import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Pages/data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Pages/Onboarding.dart';

void main() async {
  int check = 1;
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  check = sp.getInt("onboard")!;
  getTaskData();
  runApp(MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: check == 1 ? "onBoard" : "Home",
      routes: {
        "onBoard": (context) => OnBoard(),
        "Home": (context) => Home(),
      }));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final inputtext = TextEditingController();
  final desctext = TextEditingController();
  final priority = TextEditingController();
  late String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "TO DO LIST",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              builder: (context) => SingleChildScrollView(
                    child: AlertDialog(
                      title: Text("INPUT FORM"),
                      content: Column(
                        children: [
                          TextField(
                            controller: inputtext,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Tittle",
                            ),
                          ),
                          TextField(
                            controller: desctext,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Description",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: priority,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Priority",
                            ),
                          )),
                          TextButton(
                            child: Text("Choose Date"),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2300))
                                  .then((value) {
                                setState(() {
                                  date =
                                      "${value?.day.toString()}/${value?.month.toString()}/${value?.year.toString()}";
                                });
                              });
                            },
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Task obj = Task(inputtext.text, desctext.text,
                                priority.text.toString(), date, false);
                            data.insert(0, obj);
                            inputtext.clear();
                            desctext.clear();
                            priority.clear();
                            setState(() {
                              setTaskData();
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        )
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late var completedtasks;
  void calculatecomplete() {
    int count = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].status == true) count++;
    }
    completedtasks = count;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculatecomplete();
  }

  late var title = TextEditingController();
  late var description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: CircularPercentIndicator(
                                center: Text(completedtasks == 0
                                    ? "0%"
                                    : "${((completedtasks / (data.length)) * 100).round()}%"),
                                progressColor: Colors.purple,
                                radius: 70,
                                percent: completedtasks == 0
                                    ? 0.0
                                    : (completedtasks / (data.length)),
                                lineWidth: 10,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total: ${data.length}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Complete: ${completedtasks}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Active: Green",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(5),
                    color: Colors.grey.shade800))),
        SizedBox(
          height: 10,
        ),
        Text(
          "  TASK LIST",
          style: TextStyle(
              color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (BuildContext context) {
                          data.removeAt(index);
                          setTaskData();
                          setState(() {
                            calculatecomplete();
                          });
                        },
                      )
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 100,
                    padding: EdgeInsets.all(5),
                    color: data[index].active
                        ? Colors.green.shade800
                        : Colors.grey.shade800,
                    child: Column(
                      children: [
                        Container(
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          "Description",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(data[index].description),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                    onPressed: () {
                                                      if (data[index].active ==
                                                          false)
                                                        data[index]
                                                            .setActive(true);
                                                      else
                                                        data[index]
                                                            .setActive(false);
                                                      setTaskData();
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text(
                                                      "ACTIVE",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            leading: Checkbox(
                              onChanged: (value) {
                                data[index].setStatus(value);
                                setTaskData();
                                setState(() {
                                  calculatecomplete();
                                });
                              },
                              value: data[index].status,
                              checkColor: Colors.green,
                            ),
                            title: Text(
                              data[index].title,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("EDIT"),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: title,
                                                decoration: InputDecoration(
                                                  hintText: "Tittle",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              TextField(
                                                controller: description,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                  hintText: "Tittle",
                                                  border: OutlineInputBorder(),
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  data[index].setTitle(
                                                      title.text.toString());
                                                  data[index].setDescription(
                                                      description.text
                                                          .toString());
                                                  setState(() {
                                                    title.clear();
                                                    description.clear();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text("SUBMIT"))
                                          ],
                                        ));
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 30),
                                child: Text(
                                  data[index].date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "PRIORITY: ${data[index].priority}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
