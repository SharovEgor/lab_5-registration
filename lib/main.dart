import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Регистрация на игру мафия',
      routes: {
        '/': (BuildContext context) =>
            const MyHomePage(title: 'Регистрация на игру мафия'),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}

//Состояние для основного экрана
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Gender { Man, Woman }

//класс формы
class RegistrationForm {
  String fio = '';
  bool protect = false;
  int experience = 0;
  Gender? gender = Gender.Man;
  List<String> faculty = <String>[
    'ФМФ',
    'ППФ',
    'СФ',
    'ФФ',
    'ФЭУ',
    'ЕГФ',
    'ФИП',
    'ФИД',
  ];
  String? favoriteFaculty = '';

  RegistrationForm() {
    favoriteFaculty = faculty.first;
  }
}

//Второй экран
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.form});

  final RegistrationForm form;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Сводка'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ваше имя ${form.fio.toString()}'),
                if (form.gender == Gender.Woman)
                  const Text('Вы женщина')
                else
                  const Text('Вы мужчина'),
                if (form.protect) ...[
                  const Text('Вы подтвердили что вы больны'),
                  Text(
                      'Ваш опыт игры составляет ${form.experience.toString()} раз'),
                  Text(
                      'Вы указали что вы с  ${form.favoriteFaculty.toString()} мы принимаем ваш выбор'),
                ] else
                  const Text(
                      'Вы не готовы играть, а значит нам не о чем с вами разговаривать прощайте'),
              ]),
        ));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  RegistrationForm formData = RegistrationForm();
  bool accessData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Align(alignment: Alignment.bottomCenter, child: Text(widget.title)),
      ),
      body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: 500,
          child: Form(
            key: _formKey,
            onChanged: () {
              Form.of(primaryFocus!.context!)!.save();
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ваше ФИО:',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      TextFormField(validator: (value) {
                        formData.fio = value!;
                        if (value == "") return 'Пожалуйста введите свое ФИО';
                        return null;
                      }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ради статистики не более. Ваш пол?',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      RadioListTile(
                          title: const Text(
                            'Мужчина',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          value: Gender.Man,
                          groupValue: formData.gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              formData.gender = value;
                            });
                          }),
                      RadioListTile(
                          title: const Text(
                            'Женщина',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          value: Gender.Woman,
                          groupValue: formData.gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              formData.gender = value;
                            });
                          }),
                    ],
                  ),
                  Row(children: [
                    const Text(
                      'Вы готовы играть?',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Checkbox(
                        value: formData.protect,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              formData.protect = value;
                            }
                          });
                        }),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Выберите факультет',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      DropdownButton(
                          items: formData.faculty
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            );
                          }).toList(),
                          value: formData.favoriteFaculty,
                          onChanged: (String? value) {
                            setState(() {
                              formData.favoriteFaculty = value;
                            });
                          }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Сколько раз вы уже играли у нас?',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 10,
                        value: formData.experience,
                        axis: Axis.horizontal,
                        onChanged: (value) {
                          setState(() => formData.experience = value);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Мы обработаем ваши данные?',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Switch(
                          value: accessData,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) accessData = value;
                            });
                          })
                    ],
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (accessData) {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Проверка пройдена'),
                                    backgroundColor: Colors.green,
                                  ));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SecondScreen(form: formData)));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('Вы против чтобы мы обработали данные'),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Проверить форму',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ))),
                  )
                ]),
          )),
    );
  }
}

