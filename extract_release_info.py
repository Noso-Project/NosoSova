import yaml

# Function to read version from pubspec.yaml
def get_version():
    with open('pubspec.yaml', 'r') as file:
        pubspec = yaml.safe_load(file)
    version = pubspec['version']
    return version.split('+')[0]

# Function to read release notes from CHANGELOG.md
def get_release_notes(version):
    with open('CHANGELOG.md', 'r') as file:
        changelog = file.read()
    version_header = f"## v.{version}"
    start = changelog.find(version_header)
    if start == -1:
        return "No release notes found."
    start += len(version_header)
    end = changelog.find("## v.", start)
    return changelog[start:end].strip()

version = get_version()
release_notes = get_release_notes(version)

# Writing the outputs in a way that GitHub Actions can read them
print(f"::set-output name=VERSION::{version}")
print(f"::set-output name=RELEASE_NOTES::{release_notes}")
