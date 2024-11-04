import 'package:bluejobs/jobhunter_screens/details_view.dart';
import 'package:bluejobs/provider/notifications/notifications_provider.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ApplicantsPage extends StatefulWidget {
  final String jobId;

  const ApplicantsPage({super.key, required this.jobId});

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage> {
  final PostsProvider _postsProvider = PostsProvider();
  final _notificationProvider = NotificationProvider();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _applicantsStream;

  @override
  void initState() {
    super.initState();
    _applicantsStream = _postsProvider.getApplicantsStream(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Color.fromARGB(255, 7, 30, 47),
        leading: BackButton(color: const Color.fromARGB(255, 0, 0, 0)),
        title: Text(
          'Applicants',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ),
      ),
      body: Container(
       // color: Color.fromARGB(255, 7, 30, 47),
        child: StreamBuilder<QuerySnapshot>(
            stream: _applicantsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}", style: CustomTextStyle.regularText
                        .copyWith(fontSize: responsiveSize(context, 0.04)),),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No applicants",
                    style: CustomTextStyle.regularText
                        .copyWith(fontSize: responsiveSize(context, 0.04)),
                  ),
                );
              }

              final applicants = snapshot.data!.docs;


              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: applicants.length,
                      itemBuilder: (context, index) {
                        final applicant = applicants[index];

                        String applicantName = applicant['applicantName'];
                        String applicantPhone = applicant['applicantPhone'];
                        String applicantId = applicant['idOfApplicant'];
                        bool isHired = applicant['isHired'] ?? false;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                           // color: Color.fromARGB(255, 7, 30, 47),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4.0,
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: ListTile(
                              title: Text(
                                applicantName,
                                style: CustomTextStyle.semiBoldText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                              ),
                              subtitle: Text(
                                applicantPhone,
                                style: CustomTextStyle.regularText.copyWith(
                                    fontSize: responsiveSize(context, 0.04)),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 243, 107, 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: const Size(0, 53),
                                ),
                                onPressed: isHired
                                    ? null
                                    : () {
                                        _hireApplicant(applicantId);
                                      },
                                child: Text(
                                  isHired ? 'Hired' : 'Hire',
                                  style: CustomTextStyle.semiBoldText.copyWith(
                                      fontSize: responsiveSize(context, 0.04)),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobHunterResumeView(
                                      userId: applicant['idOfApplicant'],
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Confirm Deletion',
                                        style: CustomTextStyle.regularText
                                            .copyWith(
                                                fontSize: responsiveSize(
                                                    context, 0.04)),
                                      ),
                                      content: Text(
                                        'Are you sure you want to remove this applicant?',
                                        style: CustomTextStyle.regularText
                                            .copyWith(
                                                fontSize: responsiveSize(
                                                    context, 0.04)),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: CustomTextStyle.regularText
                                                .copyWith(
                                                    fontSize: responsiveSize(
                                                        context, 0.04)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Delete',
                                            style: CustomTextStyle.regularText
                                                .copyWith(
                                                    fontSize: responsiveSize(
                                                        context, 0.04)),
                                          ),
                                          onPressed: () {
                                            _deleteApplicant(applicantId);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void _hireApplicant(String applicantId) async {
    await _postsProvider.updateApplicantStatus(widget.jobId, applicantId, true);

    // Send a notification to the applicant
    await _notificationProvider.someNotification(
      receiverId: applicantId,
      senderId: _auth.currentUser!.uid,
      senderName: _auth.currentUser!.displayName ?? '',
      title: 'Job Update',
      notif: ', hired you for the job',
    );

    print('Hiring $applicantId and sending a notification');
  }

  void _deleteApplicant(String applicantId) async {
    await _postsProvider.removeApplicantFromJob(widget.jobId, applicantId);

    print('Deleting $applicantId');
  }
}
