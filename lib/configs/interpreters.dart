class Interpreters {
  static final Map<String, String> interpreters = {
    '@cryppyrc': 'Deutsch',
    '@pasichDev': 'English, Українська',
    '@estripaanisetin': 'Español',
    '@gcarreno': 'Português',
    '@maxor_vbg': 'Русский',
    '@ryanhexspoor': 'Dutch',
    '@xbt3346': 'Chinese (Simplified) - China'
  };

  static get getInterpreters => interpreters.entries
      .map((entry) => '${entry.key}: ${entry.value}')
      .join(', ');
}
