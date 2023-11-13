// ignore_for_file: use_build_context_synchronously

import 'package:elimiafrica/models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/update_verify_model.dart';
import 'auth_screen.dart';
import 'tabs_screen.dart';

class DeviceVerificationScreen extends StatefulWidget {
  static const routeName = '/device_verification';
  const DeviceVerificationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeviceVerificationScreenState createState() => _DeviceVerificationScreenState();
}

Future<UpdateVerifyModel> verifyEmail(
    String email, String verificationCode, String token) async {
  const String apiUrl = "$BASE_URL/api/new_login_confirmation/submit";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'email': email,
    'new_device_verification_code': verificationCode,
    'auth_token': token
  });

  // print(response.body);

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateVerifyModelFromJson(responseString);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<UpdateVerifyModel> resendCode(String email, String token) async {
  const String apiUrl = "$BASE_URL/api/new_login_confirmation/resend";

  final response = await http.post(Uri.parse(apiUrl), 
    body: {
      'auth_token': token
    }
  );

  // print(response.body);

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateVerifyModelFromJson(responseString);
  } else {
    throw Exception('Failed to load data');
  }
}

class _DeviceVerificationScreenState extends State<DeviceVerificationScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _isLoading = false;
  var _isResendLoading = false;

  final _boxController1 = TextEditingController();
  final _boxController2 = TextEditingController();
  final _boxController3 = TextEditingController();
  final _boxController4 = TextEditingController();
  final _boxController5 = TextEditingController();
  final _boxController6 = TextEditingController();

  final _boxFocus1 = FocusNode();
  final _boxFocus2 = FocusNode();
  final _boxFocus3 = FocusNode();
  final _boxFocus4 = FocusNode();
  final _boxFocus5 = FocusNode();
  final _boxFocus6 = FocusNode();

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focus;
  late TextEditingController _selectedController;
  late FocusNode _selectedFocus;

  String _value = '';

  @override
  void initState() {
    super.initState();
    _controllers = [
      _boxController1,
      _boxController2,
      _boxController3,
      _boxController4,
      _boxController5,
      _boxController6,
    ];
    _focus = [
      _boxFocus1,
      _boxFocus2,
      _boxFocus3,
      _boxFocus4,
      _boxFocus5,
      _boxFocus6,
    ];
  }

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {

      final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;


      final email = arguments['email'];
      final token = arguments['token'];

      final UpdateVerifyModel user = await verifyEmail(email, _value, token);

      if (user.validity == 1) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TabsScreen()));
        CommonFunctions.showSuccessToast(user.message.toString());
      } else {
        CommonFunctions.showErrorDialog(user.message.toString(), context);
      }
    } catch (error) {
      const errorMsg = 'Could not verify email!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _resend() async {
    setState(() {
      _isResendLoading = true;
    });
    try {
      final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;


      final email = arguments['email'];
      final token = arguments['token'];
      final UpdateVerifyModel user = await resendCode(email, token);

      if (user.validity == 1) {
        Navigator.of(context).pushNamed(DeviceVerificationScreen.routeName, arguments: {
          'email': email,
          'token': token,
        });
        CommonFunctions.showSuccessToast(user.message.toString());
      } else {
        CommonFunctions.showErrorDialog(user.message.toString(), context);
      }
    } catch (error) {
      const errorMsg = 'Could not send code!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isResendLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      prefixIcon: Icon(
        iconData,
        color: kTextLowBlackColor,
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      hintText: hintext,
      fillColor: kBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        key: scaffoldKey,
        elevation: 0,
        iconTheme: const IconThemeData(color: kSelectItemColor),
        backgroundColor: kBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Form(
                key: globalFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: kBackgroundColor,
                          child: Image.asset(
                            'assets/images/do_login.png',
                            height: 70,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Enter code from your email',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                            child: Text(
                              'Verification Code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) => GestureDetector(
                                onTap: () {
                                  // if nothing has been entered focus on the first box
                                  if (_value.isEmpty) {
                                    setState(() {
                                      _selectedFocus = _focus[0];
                                      _selectedController = _controllers[0];
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(_selectedFocus);
                                    // else focus on the box that was tapped
                                  } else {
                                    setState(() {
                                      _selectedFocus = _focus[index];
                                      _selectedController = _controllers[index];
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(_selectedFocus);
                                  }
                                  // print(_selectedController.text);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kBackgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    width: 15,
                                    height: 25,
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focus[index],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]+$')),
                                      ],
                                      onTap: () {
                                        // if nothing has been entered focus on the first box
                                        if (_value.isEmpty) {
                                          setState(() {
                                            _selectedFocus = _focus[0];
                                            _selectedController =
                                                _controllers[0];
                                          });
                                          FocusScope.of(context)
                                              .requestFocus(_selectedFocus);
                                        }
                                      },
                                      onChanged: (val) {
                                        if (val.isNotEmpty) {
                                          // if user enters value on a box that already has a value
                                          // the old value will be replaced by the new one
                                          if (val.length > 1) {
                                            // print('hi');
                                            _selectedController.clear();
                                            setState(() {
                                              _selectedController.text =
                                                  val.split('').last;
                                            });
                                          }
                                          // if somethin was entered add all values together
                                          setState(() {
                                            _value = _controllers.fold<String>(
                                                '',
                                                (prevVal, element) =>
                                                    prevVal + element.text);
                                          });
                                          // if user hasnt gotten to the last box the focus on the next box
                                          if (index + 1 < _focus.length) {
                                            _selectedFocus = _focus[index + 1];
                                            _selectedController =
                                                _controllers[index + 1];
                                            FocusScope.of(context)
                                                .requestFocus(_selectedFocus);
                                            // if user has gotten to last box close keyboard
                                          } else {
                                            FocusScope.of(context).unfocus();
                                            _selectedFocus = _focus[0];
                                            _selectedController =
                                                _controllers[0];
                                          }
                                        } // if val isEmpty (i.e number was deleted from the box) do nothing
                                        // print(_value);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Enter 6 digit verification code send to your email.',
                          style: TextStyle(color: kSecondaryColor),
                        ),
                        _isResendLoading
                        ? const Center(child: CircularProgressIndicator()) 
                        : TextButton(
                          onPressed: _resend,
                          child: const Text(
                            'Resend',
                            style: TextStyle(color: kBlueColor),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MaterialButton(
                                    elevation: 0,
                                    color: kPrimaryColor,
                                    onPressed: _submit,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(10),
                                      // side: const BorderSide(color: kPrimaryColor),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Verify',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Want to go Back?',
                    style: TextStyle(
                      color: kTextLowBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(AuthScreen.routeName);
                    },
                    child: const Text(
                      ' Sign In',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
