import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundscape/models/beat_model.dart';
import 'package:soundscape/service/auth_service.dart';
import 'package:soundscape/service/firestore_service.dart';
import 'package:soundscape/service/storage_service.dart';
import 'home_page.dart'; // Import your HomePage widget here

class AddBeatPage extends StatefulWidget {
  const AddBeatPage({super.key});

  @override
  _AddBeatPageState createState() => _AddBeatPageState();
}

class _AddBeatPageState extends State<AddBeatPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _releaseDateController = TextEditingController();
  final TextEditingController _bpmController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  dynamic _pickImageError;
  bool isVideo = false;
  String error = 'No error';

  bool _isLoading = false;

  File? _selectedImage;

  String _key = 'None (None)';
  String _genre =
      'Hip Hop'; // Default value should be from the dropdown items list
  XFile? _audioFile;
  Duration? _audioDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: [
          const Align(
            alignment: Alignment.center,
            child: Text('Create Track',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  textWidthBasis: TextWidthBasis.parent),
            ),
          ),
        ]),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Cover Art
              Center(
                child: Column(
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            File(_selectedImage!.path),
                          )
                        : Image.asset(
                            'assets/images/Logo.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                    TextButton(
                      onPressed: () async {
                        debugPrint('Edit cover art');
                        await _pickImageFromGallery();
                      },
                      child: const Text(
                        'Edit cover art',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text(
                      'JPG or PNG, Minimum 500x500px',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Track Title
              _buildInputField(
                label: 'Track Title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // BPM
              _buildInputField(
                label: 'BPM (Beats per minute)',
                controller: _bpmController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Key
              _buildDropdownField(
                label: 'Key',
                value: _key,
                items: [
                  'None (None)',
                  'C Major',
                  'C Minor',
                  'C# Major',
                  'C# Minor',
                  'D Major',
                  'D Minor',
                  'D# Major',
                  'D# Minor',
                  'E Major',
                  'E Minor',
                  'F Major',
                  'F Minor',
                  'F# Major',
                  'F# Minor',
                  'G Major',
                  'G Minor',
                  'G# Major',
                  'G# Minor',
                  'A Major',
                  'A Minor',
                  'A# Major',
                  'A# Minor',
                  'B Major',
                  'B Minor'
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _key = newValue ?? 'None (None)';
                  });
                },
              ),
              const SizedBox(height: 20),
              // Genre
              _buildDropdownField(
                label: 'Genre',
                value: _genre,
                items: ['Hip Hop', 'Pop', 'Rock'],
                onChanged: (String? newValue) {
                  setState(() {
                    _genre = newValue ??
                        'Hip Hop'; // Default value should be one of the items
                  });
                },
              ),
              const SizedBox(height: 20),
              // Description
              _buildInputField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Audio File Picker
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _pickAudioFile();
                      },
                      child: const Text('Upload Audio File'),
                    ),
                    if (_audioFile != null)
                      Text(
                        'Selected file: ${_audioFile!.path.split('/').last}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    if (_audioDuration != null)
                      Text(
                        'Duration: ${_audioDuration!.inMinutes}:${(_audioDuration!.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              // Publish Button
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          StorageService storageService = StorageService();
                          AuthService authService = AuthService();

                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (_audioFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please upload an audio file')),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                return;
                              }

                              // first store all files in firebase storage
                              // return the download link
                              String imageUrl = '';
                              if (_selectedImage != null) {
                                imageUrl = await storageService
                                    .uploadFile(_selectedImage!);
                                // upload image
                              }

                              String audioUrl = await storageService
                                  .uploadFile(File(_audioFile!.path));

                              debugPrint('audioUrl: $audioUrl');
                              debugPrint('imageUrl: $imageUrl'); // upload audio

                              // get the duration

                              // then upload to firestore

                              // Process the data
                              // TODO: Fix null duration problem
                              final userId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final newBeat = Beat(
                                likes: 0,
                                beatId: '', // Example beatId
                                title: _titleController.text,
                                userId: userId, // Get the user ID
                                artist: _artistController.text,
                                genre: _genre,
                                releaseDate: Timestamp.now().toString(),
                                bpm: int.parse(_bpmController.text),
                                key: _key,
                                timestamp: Timestamp.now(),
                                imageUrl: imageUrl,
                                description: _descriptionController.text,
                                audioUrl: audioUrl, // Set the audio file path
                                duration: '', // Set the duration
                              );

                              final result = await addBeats(newBeat);

                              String id = result.id.toString();

                              // update the id of the beats
                              updatingBeatsId(id);

                              // Add the beat to the user's collection in the array
                              updateUserArray(userId, id);

                              // Use `newBeat` as needed, e.g., save to database or update state
                              setState(() {
                                _titleController.clear();
                                _artistController.clear();
                                _releaseDateController.clear();
                                _bpmController.clear();
                                _imageUrlController.clear();
                                _descriptionController.clear();
                                _selectedImage = null;
                                _audioFile = null;
                                _audioDuration = null;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Beat details saved',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }
                          } catch (e) {
                            error = e.toString();
                            debugPrint(e.toString());
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Error occurred',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8.0),
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Publish'),
                      ),
                    ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      // final pickedImage =
      //     await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null && result.files.single.path != null) {
      XFile filePath = result.xFiles.first;
      setState(() {
        _audioFile = filePath;
      });

      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.getDuration();
      Duration? duration = await audioPlayer.getDuration();

      setState(() {
        _audioDuration = duration;
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF343434),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF343434),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.black,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
