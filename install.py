#!/usr/bin/env python3
"""Preview, copy, or restore the explicit home/ profile. Never reload the desktop."""
import argparse
import hashlib
import json
import shutil
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
HOME = Path.home()


def fingerprint(path):
    if path.is_symlink():
        return 'link:' + str(path.readlink())
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else None


def copy(source, target):
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.is_symlink() or (source.is_symlink() and target.exists()):
        target.unlink()
    shutil.copy2(source, target, follow_symlinks=False)


def install(apply=False):
    sources = sorted(p for p in (ROOT / 'home').rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix != '.pyc')
    if not sources:
        raise ValueError('The home/ profile is empty')
    records = []
    for source in sources:
        relative = source.relative_to(ROOT / 'home')
        target = HOME / relative
        if target.exists() and not target.is_file():
            raise ValueError(f'Not a regular file: {target}')
        print(f'{source.relative_to(ROOT)} -> {target}')
        records.append({'path': str(relative), 'installed': fingerprint(source),
                        'original': fingerprint(target)})
    if not apply:
        print('\nPreview only. Use --apply after reviewing README.md.')
        return
    base = HOME / '.local/state/dotfiles/backups'
    base.mkdir(parents=True, exist_ok=True)
    backup = Path(tempfile.mkdtemp(prefix='profile-', dir=base))
    # Finish every backup before replacing the first destination.
    for item in records:
        if item['original'] is not None:
            copy(HOME / item['path'], backup / 'home' / item['path'])
    (backup / 'manifest.json').write_text(json.dumps(records, indent=2) + '\n')
    print(f'\nBackup and rollback manifest: {backup}', flush=True)
    for item in records:
        copy(ROOT / 'home' / item['path'], HOME / item['path'])
    print('Files installed. Services and the running desktop were not changed.')


def restore(backup):
    records = json.loads((backup / 'manifest.json').read_text())
    for item in records:
        relative = Path(item['path'])
        if relative.is_absolute() or '..' in relative.parts:
            raise ValueError('Invalid backup path')
        current = fingerprint(HOME / relative)
        if current not in (item['installed'], item['original']):
            raise ValueError(f'Changed since installation: {relative}. Compare with the backup manually.')
        if item['original'] is not None and fingerprint(backup / 'home' / relative) != item['original']:
            raise ValueError(f'Missing or changed backup: {relative}')
    for item in records:
        target = HOME / item['path']
        if item['original'] is None:
            target.unlink(missing_ok=True)
        else:
            copy(backup / 'home' / item['path'], target)
    print('Original files restored. Reload services/session manually as documented.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument('--apply', action='store_true')
    mode.add_argument('--restore', type=Path, metavar='BACKUP_DIRECTORY')
    args = parser.parse_args()
    if args.restore:
        restore(args.restore)
    else:
        install(args.apply)
