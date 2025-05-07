String getRoleDescription(String role) {
  switch (role) {
    case 'T':
      return 'Podróżnik';
    case 'G':
      return 'Przewodnik';
    case 'A':
      return 'Admin';
    default:
      return 'Nieznana rola';
  }
}
