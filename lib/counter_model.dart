import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CounterModel with ChangeNotifier {
  int _counterValue = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  int get counterValue => _counterValue;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  
  final String baseUrl = 'https://letscountapi.com'; 

  
  Future<void> createCounter(String namespace, String key) async {
    _setLoading(true);
    _resetError();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}), 
      );

      print('Create counter response status: ${response.statusCode}');
      print('Create counter response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('current_value')) {
          _counterValue = data['current_value'];
          notifyListeners();
        } else {
          _setError('Invalid response format');
        }
      } else {
        _setError('Failed to create counter: ${response.body}');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> getCounterValue(String namespace, String key) async {
    _setLoading(true);
    _resetError();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$namespace/$key'),
      );

      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          if (data.containsKey('current_value')) {
            _counterValue = data['current_value'];
          } else if (data.containsKey('exists') && data['exists'] == false) {
            _counterValue = 0; 
          } else {
            _setError('Invalid response format');
          }
          notifyListeners();
        } else {
          _setError('Invalid response format');
        }
      } else {
        _setError('Failed to get counter value: ${response.body}');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> incrementCounter(String namespace, String key) async {
    _setLoading(true);
    _resetError();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/increment'),
      );

      if (response.statusCode == 200) {
        _counterValue++;
        notifyListeners();
      } else {
        _setError('Failed to increment counter: ${response.body}');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> decrementCounter(String namespace, String key) async {
    _setLoading(true);
    _resetError();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/decrement'),
      );

      if (response.statusCode == 200) {
        _counterValue--;
        notifyListeners();
      } else {
        _setError('Failed to decrement counter: ${response.body}');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  Future<void> updateCounter(String namespace, String key, int value) async {
    _setLoading(true);
    _resetError();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/update'),
        body: json.encode({'value': value}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _counterValue = value;
        notifyListeners();
      } else {
        _setError('Failed to update counter: ${response.body}');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _resetError() {
    _errorMessage = '';
  }
}