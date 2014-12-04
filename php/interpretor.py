# -*- coding: utf-8 -*-

class Interpretor(object):
    def __init__(self, configuration):
        self.configuration = configuration

    def get_packages(self):
        return []

class FPM54(Interpretor):
    def get_packages(self):
        return ['php5-fpm']


interpretors = {
    'fpm54': FPM54
}
