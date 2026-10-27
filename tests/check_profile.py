"""Static checks for the public profile; no live desktop commands."""
from pathlib import Path
import configparser
import re
import tomllib

root = Path(__file__).resolve().parents[1]
profile = root / 'home'
for path in profile.rglob('*'):
    if not path.is_file():
        continue
    text = path.read_text()
    assert not re.search(r'/home/[^/\s]+|gh[pousr]_[A-Za-z0-9]{20,}|github_pat_', text), path
    if path.suffix == '.toml':
        tomllib.loads(text)
    if path.suffix == '.ini':
        settings = configparser.ConfigParser()
        settings.read_string(text)
        assert settings['Settings']['gtk-application-prefer-dark-theme'] == '0'
    if path.suffix == '.css':
        for imported in re.findall(r'@import url\([\'"]([^\'"]+)', text):
            assert (path.parent / imported).is_file(), (path, imported)
settings = tomllib.loads((profile / '.local/state/noctalia/settings.toml').read_text())
assert 'avatar_path' not in settings['shell']
assert 'video_directory' not in settings['plugin_settings']['noctalia/mpvpaper']
assert not any(k in settings['wallpaper'] for k in ('default', 'last', 'monitors'))
assert settings['shell']['panel']['transparency_mode'] == 'glass'
lua = (profile / '.config/hypr/hyprland.lua').read_text()
assert 'name = "default-floating"' in lua
assert 'blur_strength = 0.45' in lua and 'blur_strength = 0.70' in lua
for module in re.findall(r'require\("([^\"]+)"\)', lua):
    assert (profile / '.config/hypr' / (module + '.lua')).is_file()
print('Profile checks passed: TOML, GTK preferences/imports, Lua modules, privacy constraints.')
