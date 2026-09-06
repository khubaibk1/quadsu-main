import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/provider/my_auth_provider.dart';
import 'package:quadsu_app/widget/custom_button.dart';

class EditAboutSheet extends StatefulWidget {
  final String initialAbout;
  const EditAboutSheet({super.key, required this.initialAbout});

  @override
  State<EditAboutSheet> createState() => _EditAboutSheetState();
}

class _EditAboutSheetState extends State<EditAboutSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAbout);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Edit About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: const InputDecoration(labelText: "About", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Save",
            onTap: () {
              Provider.of<MyAuthProvider>(context, listen: false).updateTutorProfile(
                context,
                request: {"about": _controller.text},
              );
            },
            color: const Color(0xFF2D3388),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class EditExpertiseSheet extends StatefulWidget {
  final String initialExpertise;
  const EditExpertiseSheet({super.key, required this.initialExpertise});

  @override
  State<EditExpertiseSheet> createState() => _EditExpertiseSheetState();
}

class _EditExpertiseSheetState extends State<EditExpertiseSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialExpertise);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Edit Areas of Expertise", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                labelText: "Expertise (comma-separated)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Save",
            onTap: () {
              Provider.of<MyAuthProvider>(context, listen: false).updateTutorProfile(
                context,
                request: {"expertise": _controller.text},
              );
            },
            color: const Color(0xFF2D3388),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class EditInterestsSheet extends StatefulWidget {
  final String initialInterests;
  const EditInterestsSheet({super.key, required this.initialInterests});

  @override
  State<EditInterestsSheet> createState() => _EditInterestsSheetState();
}

class _EditInterestsSheetState extends State<EditInterestsSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Edit Interests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                labelText: "Interests (comma-separated)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Save",
            onTap: () {
              Provider.of<MyAuthProvider>(context, listen: false).updateTutorProfile(
                context,
                request: {"interests": _controller.text},
              );
            },
            color: const Color(0xFF2D3388),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class EditMajorSheet extends StatefulWidget {
  final String initialMajor;
  const EditMajorSheet({super.key, required this.initialMajor});

  @override
  State<EditMajorSheet> createState() => _EditMajorSheetState();
}

class _EditMajorSheetState extends State<EditMajorSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMajor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Edit Major", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: "Major", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Save",
            onTap: () {
              Provider.of<MyAuthProvider>(context, listen: false).updateTutorProfile(
                context,
                request: {"speciality": _controller.text},
              );
            },
            color: const Color(0xFF2D3388),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class EditLanguagesSheet extends StatefulWidget {
  final String initialLanguages;
  const EditLanguagesSheet({super.key, required this.initialLanguages});

  @override
  State<EditLanguagesSheet> createState() => _EditLanguagesSheetState();
}

class _EditLanguagesSheetState extends State<EditLanguagesSheet> {
  List<String> selectedLanguages = [];
  final List<String> availableLanguages = ["English", "Spanish", "French", "German", "Chinese", "Arabic"];

  @override
  void initState() {
    super.initState();
    if (widget.initialLanguages.isNotEmpty) {
      selectedLanguages = widget.initialLanguages.split(',').map((e) => e.trim()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Edit Languages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableLanguages.map((lang) {
                  final isSelected = selectedLanguages.contains(lang);
                  return FilterChip(
                    label: Text(lang),
                    selected: isSelected,
                    selectedColor: const Color(0xFF6B71B9),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: const Color(0xFFF0F0F2),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedLanguages.add(lang);
                        } else {
                          selectedLanguages.remove(lang);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Save",
            onTap: () {
              Provider.of<MyAuthProvider>(context, listen: false).updateTutorProfile(
                context,
                request: {"language": selectedLanguages},
              );
            },
            color: const Color(0xFF2D3388),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
