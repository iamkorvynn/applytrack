/// Where the application was found.
enum ApplicationSource {
  linkedin,
  naukri,
  indeed,
  referral,
  companySite,
  other,
}

extension ApplicationSourceX on ApplicationSource {
  String get label {
    switch (this) {
      case ApplicationSource.linkedin:
        return 'LinkedIn';
      case ApplicationSource.naukri:
        return 'Naukri';
      case ApplicationSource.indeed:
        return 'Indeed';
      case ApplicationSource.referral:
        return 'Referral';
      case ApplicationSource.companySite:
        return 'Company site';
      case ApplicationSource.other:
        return 'Other';
    }
  }
}
