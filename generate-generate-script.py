#!/usr/bin/env python3
# coding=utf-8
import configparser
import sys


VAR_PREFIX = 'ILIBRARIAN'
ILIBRARIAN_LIBRARY_PATH='/data'
ILIBRARIAN_PATH = '/usr/share/i-librarian/www'
ILIBRARIAN_CONFIG = '${ILIBRARIAN_PATH}/ilibrarian.ini'
CONFIG = ''.join(('${', VAR_PREFIX, '_CONFIG}'))


def main(infile):
	config = configparser.ConfigParser(allow_no_value=True)
	with open(infile) as f:
		config.read_file(f)
	print('#!/bin/bash -eu')
	print()
	print('ILIBRARIAN_PATH="{path}"'.format(path=ILIBRARIAN_PATH))
	print('ILIBRARIAN_CONFIG="{cfg}"'.format(cfg=ILIBRARIAN_CONFIG))
	print()
	print('rm -f "{cfg}"'.format(cfg=CONFIG))
	print()
	for sec in config.sections():
		print('echo "[{sec}]" >> "{cfg}"'.format(sec=sec, cfg=CONFIG))
		for key in config[sec].keys():
			val = config[sec][key]
			if key == 'library_path':
				var = ILIBRARIAN_LIBRARY_PATH
			else:
				var = ''.join(('${', VAR_PREFIX, '_', key.upper(), ':-', val, '}'))
			if val.startswith('"'):
				print('echo "{key} = \\"{var}\\"" >> "{cfg}"'.format(key=key, var=var, cfg=CONFIG))
			else:
				print('echo "{key} = {var}" >> "{cfg}"'.format(key=key, var=var, cfg=CONFIG))
		print('echo >> "{cfg}"'.format(cfg=CONFIG))
		print()


if __name__ == '__main__':
	sys.exit(main(sys.argv[1]))
