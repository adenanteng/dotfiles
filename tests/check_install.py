"""Exercise the real CLI in a temporary home, without desktop/systemd calls."""
from pathlib import Path
import os
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory() as directory:
    home = Path(directory)
    env = dict(os.environ, HOME=str(home))
    def run(*args, success=True):
        result = subprocess.run([sys.executable, str(root / 'install.py'), *args],
                                env=env, capture_output=True, text=True)
        assert (result.returncode == 0) == success, result.stderr
        return result
    run()
    assert not list(home.iterdir()), 'Preview modified the home directory'
    existing = home / '.config/gtk-3.0/settings.ini'
    existing.parent.mkdir(parents=True)
    existing.write_text('original preferences\n')
    outside = home / 'original-gtk.css'
    outside.write_text('original stylesheet\n')
    link = home / '.config/gtk-3.0/gtk.css'
    link.symlink_to(outside)
    unrelated = home / 'keep-me'
    unrelated.write_text('unrelated\n')
    run('--apply')
    backup, = (home / '.local/state/dotfiles/backups').iterdir()
    assert not link.is_symlink() and outside.read_text() == 'original stylesheet\n'
    assert (backup / 'home/.config/gtk-3.0/gtk.css').is_symlink()
    installed = existing.read_text()
    existing.write_text('new user edit\n')
    run('--restore', str(backup), success=False)
    assert existing.read_text() == 'new user edit\n'
    assert not link.is_symlink(), 'Refused rollback partially restored files'
    existing.write_text(installed)
    run('--restore', str(backup))
    assert existing.read_text() == 'original preferences\n'
    assert link.is_symlink() and link.resolve() == outside
    assert not (home / '.config/hypr/hyprland.lua').exists()
    assert unrelated.read_text() == 'unrelated\n'
    run('--restore', str(backup))  # Repeat restore is safe.
print('Installer checks passed: read-only preview, backup, symlinks, edit guard, repeat rollback.')
