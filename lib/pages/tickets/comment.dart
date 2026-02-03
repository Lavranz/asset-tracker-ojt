import 'dart:io';

import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/services/ticket.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/theme/app_bar.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/custom_progress.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:apollo_tracker_mobile/widgets/custom_inputs.dart';
import 'package:apollo_tracker_mobile/widgets/custom_tags_input.dart';
import 'package:dio/dio.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:file_picker/file_picker.dart';

class Ticket {
  final String title;
  final String id;
  final String status;
  final String group;
  final String type;

  Ticket({
    required this.title,
    required this.id,
    required this.status,
    required this.group,
    required this.type,
  });
}

TicketCommentForm ticketCommentForm = TicketCommentForm();

class TicketCommentPage extends HookWidget {
  final dynamic id;

  const TicketCommentPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Use state to manage file attachments
    final attachments = useState<List<File>>([]);

    final queryClient = useQueryClient();

    final ticketQuery = useQuery(
      "ticket_detail-$id",
      () => ticket$.detail(id),
      onData: (data) {},
    );
    
    resetForm() {
      ticketCommentForm.form.patchValue({
        'bcc': <String>[],          
        'cc': <String>[],
        'message': '',
        'attachments': <File>[]
      });

      ticketCommentForm.form.markAsUntouched();
    }

    final createCommentQ = useMutation(
      'create-comment-$id',
      (data) => ticket$.createComment(id, data),
      onData: (data, revData) async {
        if (data != null) {
          queryClient.refreshQueries(['ticket_history-$id']);
          GoRouter.of(context).pop();

          toastSuccess(context, data['status']['message'] ?? '');
          resetForm();
        }
      },
      onError: (DioException error, recoveryData) {
        if (error.response!.data != null) {
          final Map<String, dynamic> errors = error.response!.data;
          ticketCommentForm.setFormErrors(errors);

          if (errors.containsKey('status')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errors['status']['message'] ?? ''),
              ),
            );
          }
        }
      },
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight =
        useMemoized(() => screenHeight * 0.6903, [screenHeight]);

    if (ticketQuery.isLoading) {
      return SpinningGradientCircle();
    }
    if (ticketQuery.hasError) {
      return const Scaffold(
          body: SafeArea(
              child: Center(
        child: Text("Error ticket details"),
      )));
    }

    // Function to pick files
    Future<void> pickFiles() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.media,
          allowMultiple: true,
        );

        if (result != null) {
          final pickedFiles = result.paths.map((path) => File(path!)).toList();
          attachments.value = [...attachments.value, ...pickedFiles];

          // Update form control
          ticketCommentForm.form.control('attachments').value =
              attachments.value;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking files: $e')),
        );
      }
    }

    useEffect(() {
      return () {
        resetForm();
      };
    }, []);

    // Function to remove a file
    void removeFile(File file) {
      attachments.value = attachments.value.where((f) => f != file).toList();
      ticketCommentForm.form.control('attachments').value = attachments.value;
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: customAppBar('Comment'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: ReactiveForm(
            formGroup: ticketCommentForm.form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticketQuery.data!.subject,
                  overflow: TextOverflow.fade,
                  style: AppTextTheme.H6MediumPrimary,
                ),
                const SizedBox(height: 16),
                TagsInput(
                  label: 'One-time Cc:',
                  hintText: 'Enter email...',
                  suggestionTags: const [
                    // 'restie@apollo.com.ph',
                    // 'restie@apollotech.co'
                  ],
                  onChanged: (tags) {
                    ticketCommentForm.form.control('cc').value = tags;
                  },
                ),
                const SizedBox(height: 16),
                TagsInput(
                  label: 'One-time Bcc:',
                  hintText: 'Enter email...',
                  suggestionTags: const [
                    // 'restie@apollo.com.ph',
                    // 'restie@apollotech.co'
                  ],
                  onChanged: (tags) {
                    ticketCommentForm.form.control('bcc').value = tags;
                  },
                ),
                const SizedBox(height: 16),
                const ReactiveTextInput(
                  label: 'Message:',
                  formControlName: 'message',
                  hintText: 'Add message...',
                  maxLines: 4,
                  required: true,
                ),
                const SizedBox(height: 16),
                // Attachments picker
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attachments',
                        style: AppTextTheme.LabelMdPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => pickFiles(), // On tap, open file picker
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: AppColors.neutral50,
                          border: Border.all(
                              color: AppColors.neutral100, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PhosphorIconsRegular.uploadSimple,
                              size: 20,
                              color: AppColors.accentPrimary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Upload files',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.accentPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Attachments preview
                if (attachments.value.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: attachments.value.length,
                      itemBuilder: (context, index) {
                        final file = attachments.value[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              _buildFilePreview(file),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => removeFile(file),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.light,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Cancel",
                  style: AppTextTheme.LabelSmMediumPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: createCommentQ.isMutating
                    ? null
                    : () {
                        print(ticketCommentForm.form.valid);
                        print(ticketCommentForm.form.value);
                        if (ticketCommentForm.form.valid) {
                          dynamic data = ticketCommentForm.form.value;
                          if (attachments.value.isNotEmpty) {
                            data = ticketCommentForm.formData;
                          }
                          createCommentQ.mutate(data);
                        } else {
                          ticketCommentForm.form.markAllAsTouched();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: createCommentQ.isMutating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Submit",
                        style: AppTextTheme.LabelSmMediumPrimary.copyWith(
                          color: AppColors.light,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build file preview
  Widget _buildFilePreview(File file) {
    // Check file type and return appropriate preview
    if (_isImageFile(file)) {
      return Image.file(
        file,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (_isVideoFile(file)) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.video_file,
            color: Colors.white,
            size: 50,
          ),
        ),
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.insert_drive_file,
            color: Colors.black,
            size: 50,
          ),
        ),
      );
    }
  }

  bool _isImageFile(File file) {
    // Check if the file is an image based on its extension
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  bool _isVideoFile(File file) {
    // Check if the file is a video based on its extension
    final extension = file.path.split('.').last.toLowerCase();
    return ['mp4', 'avi', 'mov'].contains(extension);
  }
}
