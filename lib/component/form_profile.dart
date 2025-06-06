import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final String value;
  final String hintTxt;
  final bool password;

  const InputForm({
    Key? key,
    required this.value,
    required this.hintTxt,
    this.password = false,
  }) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 5),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          style: TextStyle(color: Color.fromARGB(255, 4, 121, 2) ),
          autofocus: true,
          readOnly: true,
          initialValue: widget.value,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: widget.hintTxt,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 4, 121, 2),
                width: 2.0,
              ),
            ),
            suffixIcon: widget.password
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Color.fromARGB(255, 4, 121, 2),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}