import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _name, _age, _gender, _email, _phone, _country, _city;
  bool isLoading = false;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _email = _user?.email; // Automatically populate email field
    _loadUserData();
  }

  void _loadUserData() async {
    if (_user != null) {
      setState(() {
        isLoading = true; // Start loading
      });

      try {
        // Fetch user document from Firestore's 'profiles' collection
        DocumentSnapshot userDoc =
        await _firestore.collection('profiles').doc(_user!.uid).get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name'];
            _age = userDoc['age'];
            _gender = userDoc['gender'];
            _phone = userDoc['phone'];
            _country = userDoc['country'];
            _city = userDoc['city'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  void _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      _formKey.currentState!.save();

      try {
        // Update the document in Firestore
        await _firestore.collection('profiles').doc(_user!.uid).set({
          'name': _name,
          'age': _age,
          'gender': _gender,
          'phone': _phone,
          'country': _country,
          'city': _city,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
          _isEditing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _user != null
                ? CircleAvatar(
              backgroundColor: Colors.brown,
              child: Text(
                (_user!.displayName ?? _user!.email ?? 'U')[0]
                    .toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
                : Container(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/6.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Profile Form
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Text(
                    "Your Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xB3FFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('Name', _name, (value) {
                          _name = value;
                        }),
                        const SizedBox(height: 15),
                        _buildTextField('Age', _age, (value) {
                          _age = value;
                        }),
                        const SizedBox(height: 15),
                        _buildTextField('Gender', _gender, (value) {
                          _gender = value;
                        }),
                        const SizedBox(height: 15),
                        _buildReadOnlyField('Email', _email),
                        const SizedBox(height: 15),
                        _buildTextField('Phone', _phone, (value) {
                          _phone = value;
                        }),
                        const SizedBox(height: 15),
                        _buildTextField('Country', _country, (value) {
                          _country = value;
                        }),
                        const SizedBox(height: 15),
                        _buildTextField('City', _city, (value) {
                          _city = value;
                        }),
                        const SizedBox(height: 30),
                        if (!_isEditing)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Edit",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (_isEditing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _saveProfileData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom editable text field widget
  Widget _buildTextField(
      String label, String? initialValue, Function(String) onSaved) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
      ),
      style: GoogleFonts.poppins(color: Colors.white),
      onSaved: (value) => onSaved(value ?? ''),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      enabled: _isEditing,
    );
  }

  // Custom read-only text field widget for email
  Widget _buildReadOnlyField(String label, String? initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
      ),
      style: GoogleFonts.poppins(color: Colors.white),
      enabled: false,
    );
  }
}
