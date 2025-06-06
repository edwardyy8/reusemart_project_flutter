import 'package:flutter/material.dart';

// Padding inputForm(Function(String?) validasi, {required TextEditingController controller,
// required String hintTxt, bool password = false}) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 20, top: 5),
//     child: SizedBox(
//       width: 330,
//       child: TextFormField(
//         validator: (value) => validasi(value),
//         autofocus: true,
//         controller: controller,
//         obscureText: password,
//         decoration: InputDecoration(
//           hintText: hintTxt,
//           isDense: true,
//           contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: Colors.white,
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color.fromARGB(255, 4, 121, 2),
//               width: 2.0
//             ),
//           ),
//         ),
//       )
//     ),
//   );
// }

class InputFormWidget extends StatefulWidget {
  final Function(String?) validasi;
  final TextEditingController controller;
  final String hintTxt;
  final bool password;

  const InputFormWidget({
    Key? key,
    required this.validasi,
    required this.controller,
    required this.hintTxt,
    this.password = false,
  }) : super(key: key);

  @override
  _InputFormWidgetState createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.password; // Initialize based on password parameter
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 330,
        child: TextFormField(
          validator: (value) => widget.validasi(value),
          autofocus: true,
          controller: widget.controller,
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
                      color: Colors.grey,
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