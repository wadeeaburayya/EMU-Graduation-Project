// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:covid_app/providers/user_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pdfx/pdfx.dart';

class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  PdfController doc;
  File pcrImage;
  String jpg_pdf;
  DateTime dateTime = DateTime.now();
  var _character = 1;
  var loading = 0;
  var doc_run = 0;
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return loading == 1
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: const Text(
                  "Verify Status",
                  style: TextStyle(
                    fontFamily: 'Gothic',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Pick Date And Time of the test',
                    style: TextStyle(fontFamily: 'Gothic', fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        pickDateTime(context);
                      },
                      child: Text(
                          '${dateTime.day}/${dateTime.month}/${dateTime.year} $hours:$minutes'))
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Column(children: [
                const Text(
                  'PCR Results',
                  style: TextStyle(fontFamily: 'Gothic', fontSize: 15),
                ),
                ListTile(
                  title: const Text('Negative'),
                  leading: Radio(
                    value: 1,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Positive'),
                  leading: Radio(
                    value: 0,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ]),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Upload PCR/AntigenS',
                    style: TextStyle(fontFamily: 'Gothic', fontSize: 15),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton.icon(
                              onPressed: () {
                                pickAnImage(1, context);
                              },
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Take a Picture'))),
                      Expanded(
                          child: TextButton.icon(
                              onPressed: () {
                                pickAnImage(2, context);
                              },
                              icon: const Icon(Icons.image_outlined),
                              label: const Text('Upload from phone'))),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15)),
                      child: pcrImage == null
                          ? null
                          : jpg_pdf == '.jpg'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    pcrImage,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : doc == null
                                  ? null
                                  : PdfView(
                                      controller: doc,
                                    ),
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: 300,
                      padding: jpg_pdf == '.pdf' ? EdgeInsets.all(5) : null,
                      // padding: EdgeInsets.all(10),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (pcrImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('PCR/Antigen missing!')));
                      return;
                    }
                    setState(() {
                      loading = 1;
                    });

                    print(uid);

                    final imageUpload = FirebaseStorage.instance
                        .ref()
                        .child('user_pcrs')
                        .child(uid + jpg_pdf);
                    try {
                      await imageUpload.delete();
                    } catch (e) {
                      print(e);
                    }
                    await imageUpload.putFile(pcrImage);
                    final link = await imageUpload.getDownloadURL();
                    final latestPCR = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get();
                    try {
                      var date = DateTime.parse(
                          latestPCR.data()['pcr_time'].toDate().toString());
                      setState(() {
                        loading = 0;
                      });

                      if (date.isAfter(dateTime)) {
                        pcrImage = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upload a new PCR!')));
                        return;
                      }
                    } catch (e) {
                      print(e);
                    }

                    Timestamp myTimeStamp = Timestamp.fromDate(dateTime);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({
                      'pcr_link': link,
                      'pcr_time': myTimeStamp,
                      'Covid': _character
                    });
                    await Provider.of<UserData>(context, listen: false)
                        .getUserInfo();

                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(uid)
                        .collection('contacts')
                        .get();
                    querySnapshot.docs.forEach((element) async {
                      var currStatus = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(element.id)
                          .get();

                      if (currStatus.data()['Covid'] != 0 && _character == 0) {
                        print('Im inside');
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(element.id)
                            .update({'Covid': -1});
                      }
                    });
                    pcrImage = null;
                    // _character = 1;
                    dateTime = DateTime.now();
                    setState(() {
                      loading = 0;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PCR was uploaded!')));
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontFamily: 'Gothic'),
                  ))
            ],
          );
  }

  void pickAnImage(source, ctx) async {
    final picker = ImagePicker();
    if (source == 1) {
      final pickedImage = await picker.getImage(source: ImageSource.camera);
      setState(() {
        pcrImage = File(pickedImage.path);
      });
      jpg_pdf = '.jpg';
    } else if (source == 2) {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      doc_run += 1;
      if (result != null) {
        setState(() {
          pcrImage = File(result.files.single.path);
        });
      }
      if (doc_run == 2) {
        pcrImage = null;
        doc_run = 0;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Try Again!')));
      }

      jpg_pdf = path.extension(result.files.single.path);
      if (jpg_pdf == '.pdf' || jpg_pdf == '.jpg') {
        print('this is run');
        setState(() {
          doc = PdfController(
            document: PdfDocument.openFile(pcrImage.path),
          );
        });
      } else {
        pcrImage = null;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload either JPG or PDF')));
      }
    }
  }

  Future pickDateTime(ctx) async {
    DateTime date = await showDatePicker(
        context: ctx,
        initialDate: dateTime,
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (date == null) return;
    TimeOfDay time = await showTimePicker(
        context: ctx,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
    if (time == null) return;
    final datetime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      dateTime = datetime;
    });
  }
}
