(String, String) subtitleAndDescription(double result) {
  String subtitle = '';
  String description = '';
  if (result < 18.5) {
    subtitle = 'Underweight';
  } else if (result > 24.5) {
    subtitle = 'Overweight';
  } else {
    subtitle = 'Healthy weight';
  }
  switch (subtitle) {
    case 'Underweight':
      description = 'You are underweight';
      break;
    case 'Healthy weight':
      description = 'You are healthy';
      break;
    case 'Overweight':
      description = 'You are overweight';
      break;
  }
  return (subtitle, description);
}