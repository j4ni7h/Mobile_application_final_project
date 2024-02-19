import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BMIController extends GetxController {
  RxInt weight = 12.obs;
  RxInt age = 12.obs;
  RxDouble height = 100.0.obs;
  RxString BMI = "".obs;
  RxDouble tempBMI = 0.0.obs;
  RxString BMIStatus = "".obs;
  Rx<Color> colorStatus = Color(0xff246AFE).obs;
  RxBool hasError = false.obs; // New variable to track errors

  void calculateBMI() {
    if (hasError.value) return; // Check for error before calculating BMI
    var Hmeter = height / 100;
    tempBMI.value = weight / (Hmeter * Hmeter);
    BMI.value = tempBMI.toStringAsFixed(1);
    tempBMI.value = double.parse(BMI.value);
    findStatus();
    print(BMI);
  }

  void findStatus() {
    if (tempBMI.value >= 16 && tempBMI.value <= 16.9) {
      BMIStatus.value = "Severe undernourishment";
      colorStatus.value = Color.fromARGB(255, 251, 3, 3);
    } else if (tempBMI.value >= 17 && tempBMI.value <= 18.4) {
      BMIStatus.value = "Medium undernourishment";
      colorStatus.value = Color.fromARGB(255, 246, 70, 67);
    } else if (tempBMI.value >= 18.5 && tempBMI.value <= 24.9) {
      BMIStatus.value = "Slight undernourishment";
      colorStatus.value = Color.fromARGB(255, 237, 131, 9);
    } else if (tempBMI.value >= 25 && tempBMI.value <= 29.9) {
      BMIStatus.value = "Normal nutrition state";
      colorStatus.value = Color.fromARGB(255, 13, 255, 0);
    } else if (tempBMI.value >= 30 && tempBMI.value <= 39.9) {
      BMIStatus.value = "Overweigt";
      colorStatus.value = Color.fromARGB(255, 249, 163, 3);
    } else if (tempBMI.value < 39.9) {
      BMIStatus.value = "Obesity";
      colorStatus.value = Color(0xffFF0000);
    } else {
      BMIStatus.value = "Pathological obesity";
      colorStatus.value = Color.fromARGB(255, 254, 2, 2);
    }
  }
}

class ResultPage extends StatelessWidget {
  final BMIController bmiController = Get.find<BMIController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your BMI is ${bmiController.BMI}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'BMI Status: ${bmiController.BMIStatus}',
              style: TextStyle(
                fontSize: 20,
                color: bmiController.colorStatus.value,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final BMIController bmiController = Get.put(BMIController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Enter your height, weight, and age',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildInputCard(
                    title: 'Height (cm)',
                    controller: TextEditingController(
                      text: bmiController.height.value.toString(),
                    ),
                    onChanged: (value) {
                      int height = int.tryParse(value) ?? 0;
                      if (height <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Height cannot be less than or equal to zero"),
                          ),
                        );
                        bmiController.hasError.value = true;
                        return;
                      }
                      bmiController.height.value = height.toDouble();
                      bmiController.hasError.value = false;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildInputCard(
                    title: 'Weight (kg)',
                    controller: TextEditingController(
                      text: bmiController.weight.value.toString(),
                    ),
                    onChanged: (value) {
                      int weight = int.tryParse(value) ?? 0;
                      if (weight <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Weight cannot be less than or equal to zero"),
                          ),
                        );
                        bmiController.hasError.value = true;
                        return;
                      }
                      bmiController.weight.value = weight;
                      bmiController.hasError.value = false;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildInputCard(
                    title: 'Age',
                    controller: TextEditingController(
                      text: bmiController.age.value.toString(),
                    ),
                    onChanged: (value) {
                      int age = int.tryParse(value) ?? 0;
                      if (age <= 0) {
                        ScaffoldMessenger.
                        of(context).showSnackBar(
                          
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                                "Age cannot be less than or equal to zero"),
                          ),
                        );
                        bmiController.hasError.value = true;
                        return;
                      }
                      bmiController.age.value = age;
                      bmiController.hasError.value = false;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bmiController.calculateBMI();
                if (!bmiController.hasError.value) {
                  Get.to(ResultPage());
                }
              },
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI CALCULATOR',
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}
