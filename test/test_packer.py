#!/usr/bin/python

import os, glob, subprocess
import unittest

class TestValidate(unittest.TestCase):
  def __run(self, args):
    template_path = os.path.join(
      os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
      'packer')
    try:
      subprocess.check_call(args, cwd=template_path, stdout=subprocess.DEVNULL)
    except subprocess.CalledProcessError as e:
      self.fail('Failed with return code ({0})'.format(e.returncode))

  def test_validate(self):
    for template in glob.glob(os.path.join(template_path, '*.json')):
      self.__run(['packer', 'validate', template])

if __name__ == '__main__':
  unittest.main()
