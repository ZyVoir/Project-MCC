import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String) onSearchComplete;
  final bool isEnabled;
  const SearchFilter({
    Key? key,
    required this.textEditingController,
    required this.onSearchComplete,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  bool isShowSuffixIcon = false;
  bool isFilterEnabled = false;
  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextFormField(
        readOnly: widget.isEnabled,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.search,
        controller: widget.textEditingController,
        onEditingComplete: () {
          final value = widget.textEditingController.text;
          setState(() {
            isShowSuffixIcon = false;
            widget.textEditingController.clear();
          });
          _unfocusKeyboard();
          widget.onSearchComplete(value);
        },
        onChanged: (value) {
          setState(() {
            value.isNotEmpty ? isShowSuffixIcon = true : isShowSuffixIcon = false;
            value.isEmpty ? isFilterEnabled = true : isFilterEnabled = false;
            widget.onSearchComplete(value);
          });
        },
        decoration: InputDecoration(
          hintText: "Search PKMN Here",
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Padding(
            padding: EdgeInsetsDirectional.only(start: 10.0),
            child: Icon(
              Icons.search,
              size: 28,
            ),
          ),
          suffixIcon: isShowSuffixIcon
              ? IconButton(
                  onPressed: () {
                    widget.textEditingController.clear();
                    setState(() {
                      isShowSuffixIcon = false;
                      widget.onSearchComplete(widget.textEditingController.text);
                      _unfocusKeyboard();
                    });
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 29,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
