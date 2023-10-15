import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myid_integration/welcome.dart';
import 'package:font_avenir/font_avenir.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:myid/myid.dart';

import 'config.dart';

void main() {
  recordStackTraceAtLevel = Level.WARNING;
  Logger.root.level = Level.WARNING;

  /// Toggle to switch between MyId Prod and Stage environment
  setEnvironment(MyIdEnvironment.prod);

  if (kDebugMode) {
    Logger.root.level = Level.FINEST;
  }

  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });

  AvenirTextStyle.apply();

  runApp(const MyApp());
}

//const kMyIdLogoutUrl = 'https://login.myid.disney.com/logout';
//const kMyIdUrl =
//  'https://idp.myid.disney.com/as/authorization.oauth2?client_id=hmapp&response_type=id_token+token&redirect_uri=http://localhost:8001/myid&nonce=APPLICATION_GENERATED_ONE_TIME_NONCE&scope=openid+profile+email+relationship.employeeNumber+relationship.employeeId+relationship.employeeType+relationship.salariedCode';

typedef AuthMethod = Future Function({
required BuildContext context,
required String successUrlPrefix,
required String url,
});
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MainWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<_MainWidget> {
  final Logger _logger = Logger('_MainWidgetState');
  int buttonCount = 0;
  JwtTokenResult? _token;

  @override
  void initState() {
    super.initState();
    _checkForAuthRedirection();
  }

  void _checkForAuthRedirection() async {
    if (kIsWeb) {
      final tokens = _parseTokenFromUrl(Uri.base.toString());
      if (tokens.id?.isNotEmpty == true) {
        _token = await MyID().validateToken(tokens,
            environment: Environment.values.byName(kEnvironment.toString()));
        setState(() {});
      }
    }
  }

  Future<void> _login(BuildContext context) async {
    AuthMethod authMethod;
    void Function(dynamic result) onResponse;
    if (kIsWeb) {
      authMethod = MyID().authenticateExplicit;
      onResponse = _onExplicitResponse;
    } else {
      authMethod = MyID().authenticateImplicit;
      onResponse = _onImplicitResponse;
    }
    final result = await authMethod(
      context: context,
      url: kMyIdUrl.toString(),
      successUrlPrefix: kSuccessUrlPrefix.toString(),
    ).catchError(_onLoginError);

    onResponse(result);
  }

  void _onExplicitResponse(dynamic code) {
    // TODO: [code] must be used as param of the tokenUrl POST endpoint, ie:
    // var response = await http.post(
    //   Uri.parse('https://idp.myid.disney.com/as/token.oauth2'),
    //   body: {
    //     'grant_type': 'authorization_code',
    //     'code': code as String,
    //     'client_id': clientId,
    //     'client_secret': clientSecret,
    //     'redirect_uri': 'http://localhost:8001',
    //   },
    // );
    //
    // _logger.finest('Authenticate response: ${response.body}');
    // result = response.body;
  }

  void _onImplicitResponse(dynamic token) {
    setState(() {
      _token = token as JwtTokenResult;
    });
  }

  void _onLoginError(error) {
    if (!kIsWeb || error.toString() != MyID.kMyIdLaunchedTag) {
      _logger.severe('Authentication Error: $error');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Login failed.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Dismiss'),
              ),
            ],
          );
        },
      );
    }
  }

  /// This method is just a copy of [MyIdPlatform.parseTokenFromUrl]. Keep this
  /// in sync with that one.
  MyIdTokens _parseTokenFromUrl(String url) {
    final uri = Uri.parse(url);

    var params = uri.queryParameters;

    if (params.isEmpty) {
      params = Uri
          .parse(url.replaceFirst('#', '?'))
          .queryParameters;
    }

    const tokenStr = 'id_token=';

    final startIdx = url.indexOf(tokenStr) + tokenStr.length;
    var endIdx = url.indexOf('&', startIdx);
    if (endIdx < 0) {
      endIdx = url.length;
    }

    return MyIdTokens(
      access: params['access_token'],
      id: params['id_token'],
    );
  }

  Widget _buildTokenChildren(BuildContext context) {
    Widget child;
    if (_token == null) {
      child = const Center(child: Text('No login attempt detected'));
    } else {
      final children = <Widget>[];

      if (_token?.valid == true) {
        children.add(
          const ListTile(
            leading: Icon(
              Icons.check_circle,
              color: Color(0xFF1B5E20),
            ),
            title: Text('Login'),
            subtitle: Text('Success'),
          ),
        );

        children.add(
          ListTile(
            title: const Text('First name'),
            subtitle: Text(_token!.firstName!),
          ),
        );

        children.add(
          ListTile(
            title: const Text('Last name'),
            subtitle: Text(_token!.lastName!),
          ),
        );

        children.add(
          ListTile(
            title: const Text('Expires'),
            subtitle: Text(
              DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_token!.expires!),
            ),
          ),
        );

        children.add(
          ElevatedButton.icon(
            icon: const Icon(Icons.lock),
            label: const Text('Logout'),
            onPressed: () {
              setState(() {
                _token = null;
                MyID().logout(
                  kIsWeb ? kMyIdLogoutUrl : null,
                );
              });
            },
          ),
        );
      } else {
        children.add(
          const ListTile(
            leading: Icon(
              Icons.clear,
              color: Color(0xFFB71C1C),
            ),
            title: Text('Login'),
            subtitle: Text('Failure'),
          ),
        );

        for (var error in _token?.errors ?? []) {
          String type;
          switch (error.type) {
            case JwtTokenValidationErrorType.CLIENT_ID:
              type = 'CLIENT_ID';
              break;
            case JwtTokenValidationErrorType.EXPIRED:
              type = 'EXPIRED';
              break;
            case JwtTokenValidationErrorType.ISSUER:
              type = 'ISSUER';
              break;
            case JwtTokenValidationErrorType.SIGNATURE:
              type = 'SIGNATURE';
              break;

            default:
              type = 'UNKNOWN';
              break;
          }

          children.add(
            ListTile(
              leading: const Icon(
                Icons.cancel,
                color: Color(0xFFEF5350),
              ),
              title: Text('Error ($type)'),
              subtitle: Text(error.message),
            ),
          );
        }
      }

      child = ListView(
        children: children,
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //     title: const Text('FWR MyID App'),
      //     actions: <Widget>[
      //       ElevatedButton.icon(
      //         icon: const Icon(
      //           Icons.lock,
      //           color: Colors.white,
      //         ),
      //         label: const Text(
      //           'Login',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         onPressed: () {
      //           _login(context);
      //         },
      //       ),
      //     ],
      //   ),
      //   //body: _buildTokenChildren(context),
      //   body: _openWelcomePage(context),
      // );

      appBar: AppBar(
        title: const Center(
            child: Text("Food and Waste Reduction MyID App",
                textAlign: TextAlign.center)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSuccessMsg(context),
            _buildLoginButton(context),
            _buildLogoutButton(context),
            _buildGoToWelcome(context),
          ],
        ),
      ),
    );
  }

  _openWelcomePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Welcome()));
  }

  /*create a login and logout widget*/

  Widget _buildLoginButton(BuildContext context) {
    return _token == null && buttonCount==0
        ? ElevatedButton(
      onPressed: () {
        _login(context);
      },
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(320, 45), // specify width, height
          shape: const StadiumBorder()),
      child: const Text(
        'Login',
        style: TextStyle(
            fontFamily: 'AvenierBook',
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      ),
    )
        : Container();
  }

  Widget _buildLogoutButton(BuildContext context) {
    return (_token != null)
        ? ElevatedButton(
      onPressed: () {
        buttonCount = 1;
        setState(() {
          _token = null;
          MyID().logout(
            kIsWeb ? kMyIdLogoutUrl : null,
          );
        });
      },
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(320, 45), // specify width, height
          shape: const StadiumBorder()),
      child: const Text(
        'LogOut',
        style: TextStyle(
            fontFamily: 'AvenierBook',
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      ),
    )
        : Container();
  }

  Widget _buildSuccessMsg(BuildContext context) {
    return (_token != null)
        ? const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
        //apply padding to all four sides
        child: Text(
          'You are Successfully Logged In with MyID',
          style: TextStyle(
              fontFamily: 'AvenierBook',
              fontSize: 20.0,
              color: Colors.black38,
              fontWeight: FontWeight.w900),
        ))
        : Container();
  }

  Widget _buildGoToWelcome(BuildContext context) {
    return (_token != null)
        ? Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: TextButton(
            onPressed: () {
              _openWelcomePage(context);
            },
            child: const Text(
              'Click to start -->',
              style: TextStyle(
                  fontFamily: 'AvenierBook',
                  fontSize: 18.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w400),
            )))
        : Container();
  }
}
