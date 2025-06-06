import 'package:flutter/material.dart';
import 'package:hypersnapsdk_flutter/hypersnapsdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String faceImageUri = "";
  String docImageUri = "";

  @override
  void initState() {
    initHyperSnapSDK();
    super.initState();
  }

  Future<void> initHyperSnapSDK() async {
    String appId = "8z5j2v";
    String appKey = "8prmg1466yv7tvzwoow2";

    var initStatus = await HyperSnapSDK.initialize(
      appId,
      appKey,
      Region.asiaPacific,
    );
    print("hypersnapsdk initialisation status : $initStatus");

    /// If you need to customise HyperSnapSDK Config
    await HyperSnapSDK.setHyperSnapSDKConfig(
      hyperSnapSDKConfig: HyperSnapSDKConfig(
          //  <your-hypersnapsdk-config>
          ),
    );
  }

  /// Start user session
  Future<void> startUserSession() async {
    bool isStarted = await HyperSnapSDK.startUserSession('<session-id>');
    print("start user session status : $isStarted");
  }

  /// End user session
  Future<void> endUserSession() async {
    await HyperSnapSDK.endUserSession();
  }

  /// Start Document Capture Flow
  Future<void> startDocCapture() async {
    await HVDocsCapture.start(
      hvDocConfig: HVDocConfig(

          //  <your-doc-capture-config>
          ),
      onComplete: (hvResponse, hvError) {
        //  Handle Doc Capture flow response / error
        //  ...
        printResult(hvResponse, hvError);
        setState(() {
          docImageUri = hvResponse?.imageUri ?? "";
        });
      },
    );
  }

  /// Start Face Capture Flow
  Future<void> startFaceCapture() async {
    await HVFaceCapture.start(
      hvFaceConfig: HVFaceConfig(
          //  <your-face-capture-config>
          ),
      onComplete: (hvResponse, hvError) {
        //  Handle Face Capture flow response / error
        //  ...
        printResult(hvResponse, hvError);
        setState(() {
          faceImageUri = hvResponse?.imageUri ?? "";
        });
      },
    );
  }

  /// Start Barcode Capture Flow
  Future<void> barcodeScanCapture() async {
    await HVBarcodeScanCapture.start(
      hvBarcodeConfig: HVBarcodeConfig(
          //  <your-barcode-capture-config>
          ),
      onComplete: (hvResult, hvError) {
        //  Handle Barcode Capture flow response / error
        //  ...
        if (hvResult != null) {
          print('barcode result : $hvResult');
        }
        if (hvError != null) {
          print("error code : ${hvError.errorCode}");
          print("error message : ${hvError.errorMessage}");
        }
      },
    );
  }

  //  Make OCR call using HVNetworkHelper utility class
  Future<void> ocrCall() async {
    await HVNetworkHelper.makeOCRCall(
      endpoint: '<your-ocr-endpoint>',
      documentUri: docImageUri/*<your-doc-image-uri>*/,
      parameters: {},
      headers: {},
      onComplete: (hvResponse, hvError) {
        //  Handle OCR API Call response / error
        //  ...
        printResult(hvResponse, hvError);
      },
    );
  }

  Future<void> faceMatchCall() async {
    await HVNetworkHelper.makeFaceMatchCall(
      endpoint: '<your-face-match-endpoint>',
      faceUri: faceImageUri/*<your-face-image-uri>*/,
      documentUri: docImageUri/*<your-doc-image-uri>*/,
      faceMatchMode: FaceMatchMode.faceId,
      parameters: {},
      headers: {},
      onComplete: (hvResponse, hvError) {
        //  Handle OCR API Call response / error
        //  ...
        printResult(hvResponse, hvError);
      },
    );
  }

  void printResult(HVResponse? hvResponse, HVError? hvError) {
    if (hvResponse != null) {
      if (hvResponse.imageUri != null) {
        print("image uri : ${hvResponse.imageUri!}");
      }
      if (hvResponse.videoUri != null) {
        print("video uri : ${hvResponse.videoUri!}");
      }
      if (hvResponse.fullImageUri != null) {
        print("full image uri : ${hvResponse.fullImageUri!}");
      }
      if (hvResponse.retakeMessage != null) {
        print("retake Message : ${hvResponse.retakeMessage!}");
      }
      if (hvResponse.action != null) print("action : ${hvResponse.action!}");
      if (hvResponse.apiResult != null) {
        print("api result : ${hvResponse.apiResult!.toString()}");
      }
      if (hvResponse.apiHeaders != null) {
        print("api headers : ${hvResponse.apiHeaders!.toString()}");
      }
      if (hvResponse.rawBarcode != null) {
        print("rawBarcode : ${hvResponse.rawBarcode!}");
      }
    }
    if (hvError != null) {
      print("error code : ${hvError.errorCode}");
      print("error message : ${hvError.errorMessage}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("EKYC-HyperVerge"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const AnimationScreen()));
                      },
                      child: const Text("Animation"));
                },
              ),
              ElevatedButton(
                onPressed: () async => await startUserSession(),
                child: const Text("Start User Session"),
              ),
              ElevatedButton(
                onPressed: () async => await endUserSession(),
                child: const Text("End User Session"),
              ),
              ElevatedButton(
                onPressed: () async => await startDocCapture(),
                child: const Text("Start Document Capture Flow"),
              ),
              ElevatedButton(
                onPressed: () async => await startFaceCapture(),
                child: const Text("Start Face Capture Flow"),
              ),
              ElevatedButton(
                onPressed: () async => await barcodeScanCapture(),
                child: const Text("Start Barcode Capture Flow"),
              ),
              ElevatedButton(
                onPressed: () async => await ocrCall(),
                child: const Text("Make OCR Call"),
              ),
              ElevatedButton(
                onPressed: () async => await faceMatchCall(),
                child: const Text("Make Face Match Call"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {

        }
      })
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animation"),
      ),
      body: _contentAnimation(),
    );
  }

  Widget _contentAnimation() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: Transform.rotate(angle: _angle, child: const FlutterLogo()),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
