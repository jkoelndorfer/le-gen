#!/usr/bin/python2.7

import os
import subprocess
import sys

import yaml

os.umask(0077)

# simp_le exits with a non-zero code when it runs successfully, but performs no renewals
rc_no_renewal = 1
cert_root_dir = '/certs'

config = None
with open('/app/cert_renew.yml') as f:
    config = yaml.load(f.read())

base_command = [
    '/opt/simp_le/venv/bin/simp_le', '--email', config['email'], '-f',
    'account_key.json', '-f', 'key.pem', '-f', 'fullchain.pem', '--default_root', '/var/www',
    '--tos_sha256', config['tos_sha256']
]

for cert_dir in config['certs']:
    domains = config['certs'][cert_dir]
    target_dir = os.path.join(cert_root_dir, cert_dir)
    try:
        os.mkdir(target_dir)
    except:
        # It probably already exists
        pass
    try:
        os.chdir(target_dir)
    except:
        # We can't change into the target directory... uh oh.
        print >> sys.stderr, 'Could not access directory {} to generate cert for {}'\
                             .format(target_dir, ', '.join(domains))
        continue
    command = list(base_command)
    for domain in domains:
        command.extend(['-d', domain])
    try:
        subprocess.check_call(command)
    except subprocess.CalledProcessError as e:
        if e.returncode != rc_no_renewal:
            print >> sys.stderr, 'Failed while trying to generate cert for {}'\
                                .format(', '.join(domains))
