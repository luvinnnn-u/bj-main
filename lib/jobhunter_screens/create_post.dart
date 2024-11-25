import 'package:bluejobs/model/posts_model.dart';
import 'package:bluejobs/navigation/jobhunter_navigation.dart';
import 'package:bluejobs/provider/posts_provider.dart';
import 'package:bluejobs/styles/custom_button.dart';
import 'package:bluejobs/styles/custom_theme.dart';
import 'package:bluejobs/styles/responsive_utils.dart';
import 'package:bluejobs/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // firestore storage access
  final PostsProvider createdPost = PostsProvider();
  // text controllers
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  // final _rateController = TextEditingController();

  final _descriptionFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  // final _rateFocusNode = FocusNode();

  bool _isDescriptionFocused = false;
  // bool _isRateFocused = false;
  bool _isTypeFocused = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _typeController.dispose();
    // _rateController.dispose();
    _descriptionFocusNode.dispose();
    _typeFocusNode.dispose();
    // _rateFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode.addListener(_onFocusChange);
    // _rateFocusNode.addListener(_onFocusChange);
    _typeFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isDescriptionFocused = _descriptionFocusNode.hasFocus;
      // _isRateFocused = _rateFocusNode.hasFocus;
      _isTypeFocused = _typeFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Post',
          style: CustomTextStyle.semiBoldText
              .copyWith(fontSize: responsiveSize(context, 0.04)),
        ), // You can add a title or other properties here
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a Post',
                  style: CustomTextStyle.semiBoldText.copyWith(
                    fontSize: responsiveSize(context, 0.05),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('Description'),
              TextField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                decoration: customInputDecoration(''),
                cursorColor: Color.fromARGB(255, 7, 30, 47),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
                maxLines: 4,
              //  minLines: 1,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
              ),
              if (_isDescriptionFocused)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Provide a detailed description.',
                      style: CustomTextStyle.regularText,
                    ),
                  ),
                ),
           
              const SizedBox(height: 20),
              _buildLabel('Type Of Job'),
              TextField(
                controller: _typeController,
                focusNode: _typeFocusNode,
                decoration: customInputDecoration(''),
                cursorColor: Color.fromARGB(255, 7, 30, 47),
                style: CustomTextStyle.regularText.copyWith(
                  fontSize: responsiveSize(context, 0.04),
                ),
                maxLines: 10,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.left,
              ),
              if (_isTypeFocused)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Example: Construction, Paint Job, Sales lady/boy, Laundry, Cook',
                    style: CustomTextStyle.regularText,
                  ),
                ),
              const SizedBox(height: 15),
              Column(
                children: [
                  CustomButton(
                    onPressed: () => createPost(context),
                    buttonText: 'Post',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 53,
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        _descriptionController.clear();
                        _typeController.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JobhunterNavigation(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color.fromARGB(255, 7, 30, 47)),
                        backgroundColor: const Color.fromARGB(255, 7, 30, 47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: CustomTextStyle.regularText
                            .copyWith(color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  //posting
  void createPost(BuildContext context) async {
    if (_descriptionController.text.isNotEmpty &&
        _typeController.text.isNotEmpty) {
      String description = _descriptionController.text;
      String type = _typeController.text;
      // String rate = _rateController.text;
      var postDetails = Post(
        description: description,
        type: type,
        // rate: rate,
      );

      try {
        await Provider.of<PostsProvider>(context, listen: false)
            .addPost(postDetails);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const JobhunterNavigation()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Failed to create post: $e',
              style: CustomTextStyle.regularText,
            ),
          ),
        );
      }
    }
  }

  
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        label,
        style: CustomTextStyle.semiBoldText.copyWith(
          fontSize: responsiveSize(context, 0.04),
        ),
      ),
    );
  }

}


