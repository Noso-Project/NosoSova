# scripts/extract_release_info.py
import yaml
import re

# Читання файлу pubspec.yaml для отримання версії
with open('pubspec.yaml', 'r') as file:
    pubspec = yaml.safe_load(file)
    version = pubspec['version']

# Видалення коду версії після +
version = version.split('+')[0]

# Читання файлу CHANGELOG.md для отримання опису релізу
with open('CHANGELOG.md', 'r') as file:
    changelog = file.read()

# Пошук опису для необхідної версії
pattern = rf"## v\.{version}\n\n([\s\S]+?)(?=\n##|\Z)"
match = re.search(pattern, changelog)
release_notes = match.group(1).strip() if match else "No release notes found."

# Запис інформації у файл для використання в GitHub Actions
with open('release_info.txt', 'w') as file:
    file.write(f"VERSION={version}\n")
    file.write(f"RELEASE_NOTES<<EOF\n{release_notes}\nEOF\n")
