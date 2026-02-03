import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TagsInput extends StatefulWidget {
  TagsInput({
    Key? key,
    required this.label,
    this.hintText,
    this.suggestionTags,
    this.onChanged
  }) : super(key: key);

  final String label;

  final String? hintText;

  final List<String>? suggestionTags;

  final Function(List<String>)? onChanged;

  @override
  State<TagsInput> createState() => _StringTagsState();
}

class _StringTagsState extends State<TagsInput>  {

  final _stringTagController = StringTagController();

  late double _distanceToField;

  late List<String> _initialTags;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
    _stringTagController.addListener(_onTagsChanged);
  }

  @override
  void initState() {
    super.initState();
    _initialTags = widget.suggestionTags ?? [''];
  }

  @override
  void dispose() {
    _stringTagController.removeListener(_onTagsChanged);
    super.dispose();
  }

  void _onTagsChanged() {
    // Notify parent when tags change
    widget.onChanged!(_stringTagController.getTags ?? []);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextTheme.LabelMdPrimary,
        ),
        const SizedBox(height:8,),
        Autocomplete<String>(
          optionsViewBuilder: (context, onSelected, options) {
            final screenWidth = MediaQuery.of(context).size.width;

            return Container(
              width: screenWidth * .8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8)
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: 2,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return TextButton(
                          onPressed: () {
                            onSelected(option);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Removes border radius
                            ),
                            backgroundColor: Colors.transparent, // Removes hover color
                            foregroundColor: Colors.transparent,
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(Colors.transparent)
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              option,
                              textAlign: TextAlign.left,
                              style: AppTextTheme.LabelMdPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _initialTags.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selectedTag) {
            _stringTagController.onTagSubmitted(selectedTag);
          },
          fieldViewBuilder: (context, textEditingController, focusNode,
              onFieldSubmitted) {

            return TextFieldTags<String>(
              textEditingController: textEditingController,
              focusNode: focusNode,
              textfieldTagsController: _stringTagController,
              initialTags: const [],
              textSeparators: const [' ', ','],
              letterCase: LetterCase.normal,
              validator: (String tag) {
                if (_stringTagController.getTags!.contains(tag)) {
                  return 'You\'ve already entered that';
                }
                return null;
              },
              inputFieldBuilder: (context, inputFieldValues) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    controller: inputFieldValues.textEditingController,
                    focusNode: inputFieldValues.focusNode,
                    decoration: InputDecoration(

                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.strokePrimary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.surfaceInvertPrimary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      helperStyle: const TextStyle(
                        color: AppColors.strokePrimary,
                      ),
                      hintText: inputFieldValues.tags.isNotEmpty
                          ? ''
                          : widget.hintText,
                      errorText: inputFieldValues.error,
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: _distanceToField * 0.74),
                      prefixIcon: inputFieldValues.tags.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: SingleChildScrollView(
                                controller:
                                    inputFieldValues.tagScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: inputFieldValues.tags
                                        .map((String tag) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      color: AppColors.primary50,
                                      border: Border.all(
                                        color: AppColors.primary600, // Set border color
                                        width: 1,         // Set border width
                                      ),
                                    ),
                                    margin:
                                        const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Text(
                                            tag,
                                            style: const TextStyle(
                                                color: AppColors.surfaceInvertPrimary),
                                          )
                                        ),
                                        const SizedBox(width: 4.0),
                                        InkWell(
                                          child: const Icon(
                                            Icons.close,
                                            size: 18.0,
                                            color: AppColors.surfaceInvertPrimary,
                                          ),
                                          onTap: () {
                                            inputFieldValues
                                                .onTagRemoved(tag);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              ),
                            )
                          : null,
                    ),
                    onChanged: inputFieldValues.onTagChanged,
                    onSubmitted: inputFieldValues.onTagSubmitted,
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}