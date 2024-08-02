import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String urlStart = Platform.isAndroid
    ?
    'http://${dotenv.env["IPADD"]}:3000'
    : 'http://localhost:3000';

String urlSocket = 'http://${dotenv.env["IPADD"]}:5000';
