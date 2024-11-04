import 'package:bluejobs/jobhunter_screens/jobhunter_profile.dart';
import 'package:bluejobs/model/work_experience_model.dart';
import 'package:bluejobs/provider/work_experience_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import for date formatting

class WorkExpPage extends StatefulWidget {
  const WorkExpPage({super.key});

  @override
  State<WorkExpPage> createState() => _WorkExpPageState();
}

// class _WorkExpPageState extends State<WorkExpPage> {
//   DateTime? selectedDate; // Variable to hold the selected date

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
// leading: BackButton(color: Color.fromARGB(255, 7, 30, 47), onPressed: () => Navigator.of(context).pop(),),
// title: Text('Work Experiences', style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),),
//       ),
//       body: Container(
//          color: Color.fromARGB(255, 255, 255, 255),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel('Company Name'),        
//                    TextFormField(
//                  decoration: customInputDecoration(''),
//               ), 
//               const SizedBox(height: 10,),
//                 _buildLabel('Position Title'),           
//                   TextFormField(
//                  decoration: customInputDecoration(''),
//               ),
//                const SizedBox(height: 10,),
          

//               _buildLabel('Duration'),
//               TextFormField(
//                 decoration: customInputDecoration(
//                   'From',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_today),
//                     onPressed: () async {
//                       // Show date picker when icon is pressed
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate ?? DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );

//                       if (pickedDate != null) {
//                         setState(() {
//                           selectedDate = pickedDate; // Update the selected date
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               TextFormField(
//                 decoration: customInputDecoration(
//                   'To',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_today),
//                     onPressed: () async {
//                       // Show date picker when icon is pressed
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate ?? DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2101),
//                       );

//                       if (pickedDate != null) {
//                         setState(() {
//                           selectedDate = pickedDate; // Update the selected date
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10,),
//               CustomButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => JobHunterProfilePage() ));
//                 },
//                  buttonText: 'Submit')

//             ],

//           ),
//       ),
//       ),
//     );
//   }



class _WorkExpPageState extends State<WorkExpPage> {
  DateTime? fromDate;
  DateTime? toDate; // Variable to hold the selected end date
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController positionTitleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Color.fromARGB(255, 7, 30, 47), onPressed: () => Navigator.of(context).pop()),
        title: Text('Work Experiences', style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04))),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel( context, 'Company Name'),
              TextFormField(
                controller: companyNameController,
                decoration: customInputDecoration(''),
              ),
              const SizedBox(height: 10),
              _buildLabel(context, 'Position Title'),
              TextFormField(
                controller : positionTitleController,
                decoration: customInputDecoration(''),
              ),
              const SizedBox(height: 10),
              _buildLabel(context, 'Duration'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: customInputDecoration(
                        'From',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            // Show date picker when icon is pressed
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: fromDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                fromDate = pickedDate; // Update the selected start date
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: customInputDecoration(
                        'To',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            // Show date picker when icon is pressed
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: toDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                toDate = pickedDate; // Update the selected end date
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  // Add work experience to provider
                  Provider.of<WorkExperienceProvider>(context, listen: false).addWorkExperience(
                    WorkExperience(
                      companyName: companyNameController.text,
                      positionTitle: positionTitleController.text,
                      duration: '${DateFormat.yMMMd().format(fromDate!)} - ${DateFormat.yMMMd().format(toDate!)}',
                    ),
                  );

                  Navigator.push(context, MaterialPageRoute(builder: (context) => JobHunterProfilePage()));
                },
                buttonText: 'Submit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}




  //for text putside field
  // Widget _buildLabel(String label) {
  // return Padding(
  //   padding: const EdgeInsets.only(bottom: 5.0),
  //   child: Text(
  //     label,
  //     style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
  //   ),
  // );
  Widget _buildLabel(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: Text(
      label,
      style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
    ),
  );

}
