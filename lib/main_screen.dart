import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _namespaceController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final counterModel = Provider.of<CounterModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LetsCount'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _namespaceController,
                      decoration: const InputDecoration(
                        labelText: 'Namespace',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: 'Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String namespace = _namespaceController.text.trim();
                        String key = _keyController.text.trim();

                        if (namespace.isNotEmpty && key.isNotEmpty) {
                          await counterModel.createCounter(namespace, key);
                          await counterModel.getCounterValue(namespace, key);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter both namespace and key')),
                          );
                        }
                      },
                      child: const Text('Create Counter'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Counter Value: ${counterModel.counterValue}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    if (counterModel.isLoading) const CircularProgressIndicator(),
                    if (counterModel.errorMessage.isNotEmpty)
                      Text(
                        counterModel.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String namespace = _namespaceController.text.trim();
                            String key = _keyController.text.trim();
                            if (namespace.isNotEmpty && key.isNotEmpty) {
                              await counterModel.incrementCounter(namespace, key);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter both namespace and key')),
                              );
                            }
                          },
                          child: const Text('Increment'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String namespace = _namespaceController.text.trim();
                            String key = _keyController.text.trim();
                            if (namespace.isNotEmpty && key.isNotEmpty) {
                              await counterModel.decrementCounter(namespace, key);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter both namespace and key')),
                              );
                            }
                          },
                          child: const Text('Decrement'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}