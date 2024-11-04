import 'package:bluejobs/employer_screens/job_posts_page.dart';
import 'package:bluejobs/model/posts_model.dart';
import 'package:bluejobs/navigation/employer_navigation.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CreateJobPostPage extends StatefulWidget {
  const CreateJobPostPage({super.key});

  @override
  State<CreateJobPostPage> createState() => _CreateJobPostPageState();
}

class _CreateJobPostPageState extends State<CreateJobPostPage> {
  final PostsProvider jobpostdetails = PostsProvider();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _typeController = TextEditingController();
  final _startDateController = TextEditingController();
  final _workingHoursController = TextEditingController();
  DateTime? _selectedDate;

  List<LatLng> routePoints = [];

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _workingHoursFocusNode = FocusNode();

  bool _isTitleFocused = false;
  bool _isDescriptionFocused = false;
  bool _isLocationFocused = false;
  bool _isTypeFocused = false;
  bool _isStartDateFormatFocused = false;
  bool _isWorkingHoursFocused = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _typeController.dispose();
    _startDateController.dispose();
    _workingHoursController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _typeFocusNode.dispose();
    _locationFocusNode.dispose();
    _startDateFocusNode.dispose();
    _workingHoursFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);
    _typeFocusNode.addListener(_onFocusChange);
    _locationFocusNode.addListener(_onFocusChange);
    _startDateFocusNode.addListener(_onFocusChange);
    _workingHoursFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isTitleFocused = _titleFocusNode.hasFocus;
      _isDescriptionFocused = _descriptionFocusNode.hasFocus;
      _isLocationFocused = _locationFocusNode.hasFocus;
      _isTypeFocused = _typeFocusNode.hasFocus;
      _isStartDateFormatFocused = _startDateFocusNode.hasFocus;
      _isWorkingHoursFocused = _workingHoursFocusNode.hasFocus;
    });
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _startDateController.text = DateFormat('MM-dd-yyyy').format(picked);
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(

       leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
    ),
    body: Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.only( left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Create Job Post',
                      style: CustomTextStyle.semiBoldText.copyWith(
                        fontSize: responsiveSize(context, 0.05),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildLabel('Title', ),
                    TextField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      decoration: customInputDecoration(''),
                      cursorColor: Colors.white,
                       style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
                      maxLines: 10,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                    ),
                    if (_isTitleFocused)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Enter the title of your post.',
                          style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.03)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildLabel('Description', ),
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      decoration: customInputDecoration(''),
                      cursorColor: Colors.white,
                       style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),

                      maxLines: 20,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                    ),
                    if (_isDescriptionFocused)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Provide a detailed description.',
                          style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.03)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildLabel('Type of Job', ),
                    DropdownButtonFormField(
                      decoration: customInputDecoration('').copyWith(
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                      focusNode: _typeFocusNode,
                      value: _typeController.text.isEmpty
                          ? null
                          : _typeController.text,
                      onChanged: (newValue) {
                        setState(() {
                          _typeController.text = newValue as String;
                        });
                      },
                      items: [
                        // 'Contractual Job',
                        // 'Stay In Job',
                        // 'Project Based',
                       ' Full-Time Job' ,
'Part-Time Job',
'Freelance',
'Temporary Job',
'Internship',
'Commission-Based',
'Seasonal Job',


                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: CustomTextStyle.regularText.copyWith(
                                fontSize: responsiveSize(context, 0.04)),
                          ),
                        );
                      }).toList(),
                      //dropdownColor: Color.fromARGB(255, 7, 30, 47),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Location', ),
                    TextField(
                      controller: _locationController,
                      focusNode: _locationFocusNode,
                      decoration: customInputDecoration(''),
                      cursorColor: Colors.white,
                       style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
                      maxLines: 5,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                    ),
                    if (_isLocationFocused)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Enter address Ex. Illawod Poblacion, Legazpi City, Albay',
                          style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.03)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildLabel('Start Date'),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: GestureDetector(
                              onTap: () => _selectStartDate(context),
                              child: AbsorbPointer(
                             //  child: _buildLabel('Title', ),
                                child: TextField(
                                  controller: _startDateController,
                                  focusNode: _startDateFocusNode,
                                  decoration: customInputDecoration(
                                    '',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 7, 30, 47),),

                                      onPressed: () => _selectStartDate(context),
                                    ),
                                    
                                  ),
                                  cursorColor: const Color.fromARGB(255, 0, 0, 0),
                       style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),


DropdownButtonFormField(
  decoration: customInputDecoration('Working Hours').copyWith(
    suffixIcon: Icon(
      Icons.arrow_drop_down,
      color: Colors.white,
    ),
    
  ),
                       style: CustomTextStyle.regularText.copyWith(
                              fontSize: responsiveSize(context, 0.04)),
  
  focusNode: _workingHoursFocusNode,
  value: _workingHoursController.text.isEmpty
      ? null
      : _workingHoursController.text,
  onChanged: (newValue) {
    setState(() {
      _workingHoursController.text = newValue as String;
    });
  },
  items: [
    '8am - 5pm',
    '9am - 6pm',
    '10am - 7pm',
    '7am - 3pm',
    '6am - 2pm',
    'Flexible',
    'Rotating Shifts',
    'Night Shift',
    'Morning Shift',
    'Afternoon Shift',
  ].map((hours) {
    return DropdownMenuItem(
      value: hours,
      child: Text(
        hours,
        style: CustomTextStyle.regularText.copyWith(
          fontSize: responsiveSize(context, 0.04),
        ),
      ),
    );
  }).toList(),
  dropdownColor: Color.fromARGB(255, 7, 30, 47),
),
                    const SizedBox(height: 20),
                  Column(
  children: [
  
   CustomButton(
      onPressed: () => addJobPost(context),
      buttonText: 'Save',
    
    ),
    SizedBox(height: 10),
    OutlinedButton(
      onPressed: () {
        _titleController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _typeController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployerNavigation()
              ),
        );
      },
      child: Text(
        'Cancel', style: CustomTextStyle.semiBoldText.copyWith(color: Colors.orange, fontSize: responsiveSize(context, 0.04)),
        
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    const SizedBox(height: 10),
    OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const JobPostsPage()),
        );
      },
      child: Text(
        'Go to Job Posts History',
       // style: const TextStyle(color: Color.fromARGB(255, 255, 165, 0)),
       style: CustomTextStyle.semiBoldText.copyWith(color: Colors.orange, fontSize: responsiveSize(context, 0.04)),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
  ],
),
            
                  ]
              )
              ),
            ),
          );

        },
      ),
    ),
  );
}



// Helper function to build labels
Widget _buildLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: Text(
      label,
      style: CustomTextStyle.semiBoldText.copyWith(fontSize: responsiveSize(context, 0.04)),
    ),
  );
}

  void addJobPost(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _workingHoursController.text.isNotEmpty) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      String type = _typeController.text;
      String location = _locationController.text;
      String startDate = _startDateController.text;
      String workingHours = _workingHoursController.text;

      var jobPostDetails = Post(
        title: title,
        description: description,
        type: type,
        location: location,
        startDate: startDate,
        workingHours: workingHours,
      );

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addPost(jobPostDetails);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmployerNavigation()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }
}
