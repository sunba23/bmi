String? validateDouble (value, label) {
  try {
    if (value == null || value.isEmpty || double.tryParse(value) == null) {
      return 'Please enter a valid $label';
    }
    return null;
  } catch (e) {
    return 'Please enter a valid $label';
  }
}