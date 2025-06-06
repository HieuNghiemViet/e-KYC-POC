import 'dart:math';
import 'package:ekyc_hyperverge/enum.dart';
import 'package:flutter/material.dart';
import 'package:hyperkyc_flutter/hyperkyc_config.dart';
import 'package:hyperkyc_flutter/hyperkyc_flutter.dart';
import 'package:hyperkyc_flutter/hyperkyc_result.dart';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String appId = "8z5j2v";
  String appKey = "8prmg1466yv7tvzwoow2";
  String workfloweKYC = "workflow_ekyc";
  String workflowNFC = "workflow_ekyc_nfc";

  @override
  void initState() {
    super.initState();
    prefetch();
  }

  void prefetch() {
    HyperKyc.prefetch(
      appId: appId,
      workflowId: workfloweKYC,
    );
  }

  void startUserSession({EKYCType eKycType = EKYCType.ekyc}) async {
    try {
      var hyperKycConfig = HyperKycConfig.fromAppIdAppKey(
        appId: appId,
        appKey: appKey,
        workflowId: eKycType == EKYCType.ekyc ? workfloweKYC : workflowNFC,
        transactionId: Random().nextInt(1000).toString(),
      );

      HyperKycResult hyperKycResult =
          await HyperKyc.launch(hyperKycConfig: hyperKycConfig);

      developer.log("HyperKycResult: ${hyperKycResult.getRawDataJsonString()}");

      handleResult(hyperKycResult);
    } catch (e) {
      developer.log("Error starting user session: $e");
    }
  }

  void handleResult(HyperKycResult hyperKycResult) {
    String? status = hyperKycResult.status?.value;
    switch (status) {
      case 'auto_approved':
        // workflow successful
        developer.log('workflow successful - auto approved');
      case 'auto_declined':
        // workflow successful;
        developer.log('workflow successful - auto declined');
      case 'needs_review':
        // workflow successful
        developer.log('workflow successful - needs review');
      case 'error':
        // failure
        developer.log('failure');
      case 'user_cancelled':
        // user cancelled
        developer.log('user cancelled');
      default:
        developer.log('contact HyperVerge for more details');
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
              // Builder(
              //   builder: (BuildContext context) {
              //     return ElevatedButton(
              //         onPressed: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (_) => const AnimationScreen()));
              //         },
              //         child: const Text("Animation"));
              //   },
              // ),
              ElevatedButton(
                onPressed: () => startUserSession(),
                child: const Text("Workflow_ekyc"),
              ),
              ElevatedButton(
                onPressed: () => startUserSession(
                  eKycType: EKYCType.ekycNFC,
                ),
                child: const Text("Workflow_ekyc_nfc"),
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
        if (status == AnimationStatus.completed) {}
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
