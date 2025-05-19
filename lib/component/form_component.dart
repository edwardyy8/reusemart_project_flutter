import 'package:flutter/material.dart';

Padding inputForm(Function(String?) validasi, {required TextEditingController controller,
required String hintTxt, bool password = false}) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 5),
    child: SizedBox(
      width: 330,
      child: TextFormField(
        validator: (value) => validasi(value),
        autofocus: true,
        controller: controller,
        obscureText: password,
        decoration: InputDecoration(
          hintText: hintTxt,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 4, 121, 2),
              width: 2.0
            ),
          ),
        ),
      )
    ),
  );
}