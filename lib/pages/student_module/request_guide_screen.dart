import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quadsu_app/services/newest_webservices.dart';
import 'package:quadsu_app/widget/custom_text_field.dart';
import 'package:quadsu_app/functions/validation_functions.dart';

class RequestGuideScreen extends StatefulWidget {
  const RequestGuideScreen({super.key});

  @override
  State<RequestGuideScreen> createState() => _RequestGuideScreenState();
}

class _RequestGuideScreenState extends State<RequestGuideScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otherAnswerController = TextEditingController();
  
  final TextEditingController uni1NameController = TextEditingController();
  final TextEditingController uni1MajorController = TextEditingController();
  final TextEditingController uni1NoteController = TextEditingController();
  
  final TextEditingController uni2NameController = TextEditingController();
  final TextEditingController uni2MajorController = TextEditingController();
  final TextEditingController uni2NoteController = TextEditingController();
  
  final TextEditingController uni3NameController = TextEditingController();
  final TextEditingController uni3MajorController = TextEditingController();
  final TextEditingController uni3NoteController = TextEditingController();

  String? highSchool;
  String? college;
  String? parentGuardians;
  bool showOtherInput = false;

  final Color kPrimaryBlue = const Color(0xFF2D3388);
  final Color kAccentOrange = const Color(0xFFF79E1B);

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Submitting...');

      Map<String, dynamic> request = {
        'fname': fnameController.text.trim(),
        'lname': lnameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'high-school': highSchool ?? '',
        'college': college ?? '',
        'parent_guardians': parentGuardians ?? '',
        'other_answer': otherAnswerController.text.trim(),
        'uni-1-name': uni1NameController.text.trim(),
        'uni-1-major': uni1MajorController.text.trim(),
        'uni-1-additional-note': uni1NoteController.text.trim(),
        'uni-2-name': uni2NameController.text.trim(),
        'uni-2-major': uni2MajorController.text.trim(),
        'uni-2-additional-note': uni2NoteController.text.trim(),
        'uni-3-name': uni3NameController.text.trim(),
        'uni-3-major': uni3MajorController.text.trim(),
        'uni-3-additional-note': uni3NoteController.text.trim(),
        'recaptcha_token': 'mobile_app_bypass',
      };

      var response = await NewestWebServices.getResponse(
        apiUrl: 'https://quadsu.com/api/request-guide',
        request: request,
        apiMethod: ApiMethod.post,
        showSuccessMessage: true,
      );

      EasyLoading.dismiss();

      if (response.status == 1 && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request a Guide', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requester Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlue,
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: fnameController,
                hintText: 'First Name',
                validator: (val) => ValidationFunction.requiredValidation(val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: lnameController,
                hintText: 'Last Name',
                validator: (val) => ValidationFunction.requiredValidation(val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (val) => ValidationFunction.emailValidation(val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: phoneController,
                hintText: 'Phone number (optional)',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),

              Text(
                'Please select one of the following:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // High School Section
              Text(
                'High School:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  _buildRadioChip('Sophomore', highSchool, (val) {
                    setState(() => highSchool = val);
                  }),
                  _buildRadioChip('Junior', highSchool, (val) {
                    setState(() => highSchool = val);
                  }),
                  _buildRadioChip('Senior', highSchool, (val) {
                    setState(() => highSchool = val);
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // College Section
              Text(
                'College:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  _buildRadioChip('Freshman', college, (val) {
                    setState(() => college = val);
                  }),
                  _buildRadioChip('Junior', college, (val) {
                    setState(() => college = val);
                  }),
                  _buildRadioChip('Senior', college, (val) {
                    setState(() => college = val);
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Parents/Guardians Section
              Text(
                'Parents/Guardians',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildRadioChip('Other', parentGuardians, (val) {
                setState(() {
                  parentGuardians = val;
                  showOtherInput = val == 'Other';
                });
              }),
              
              if (showOtherInput) ...[
                const SizedBox(height: 12),
                CustomTextField(
                  controller: otherAnswerController,
                  hintText: 'Please specify',
                ),
              ],
              const SizedBox(height: 32),

              Text(
                'You can request up to 3 colleges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // College/University #1
              _buildCollegeSection(
                number: 1,
                nameController: uni1NameController,
                majorController: uni1MajorController,
                noteController: uni1NoteController,
              ),

              // College/University #2
              _buildCollegeSection(
                number: 2,
                nameController: uni2NameController,
                majorController: uni2MajorController,
                noteController: uni2NoteController,
              ),

              // College/University #3
              _buildCollegeSection(
                number: 3,
                nameController: uni3NameController,
                majorController: uni3MajorController,
                noteController: uni3NoteController,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioChip(String label, String? groupValue, Function(String) onChanged) {
    bool isSelected = groupValue == label;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCollegeSection({
    required int number,
    required TextEditingController nameController,
    required TextEditingController majorController,
    required TextEditingController noteController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'College/University #$number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kPrimaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: nameController,
          hintText: 'Name',
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: majorController,
          hintText: 'Major',
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: noteController,
          hintText: 'Enter Additional Note',
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
