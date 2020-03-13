#!/usr/bin/env bash
# See: https://ujjwalbhardwaj.me/post/disable-download-button-on-the-sagemaker-jupyter-notebook
# Creating ForbidFilesHandler class, overriding the default files_handler_class
set -e
set -o pipefail

cat <<END >/home/ec2-user/.jupyter/handlers.py
from tornado import web
from notebook.base.handlers import IPythonHandler

class ForbidFilesHandler(IPythonHandler):
    @web.authenticated
    def head(self, path):
        self.log.info("HEAD: File download forbidden.")
        raise web.HTTPError(403)

    @web.authenticated
    def get(self, path, include_body=True):
        self.log.info("GET: File download forbidden.")
        raise web.HTTPError(403)

END

# Updating the files_handler_class
cat <<END >>/home/ec2-user/.jupyter/jupyter_notebook_config.py
import os, sys
sys.path.append('/home/ec2-user/.jupyter/')
import handlers
c.ContentsManager.files_handler_class = 'handlers.ForbidFilesHandler'
c.ContentsManager.files_handler_params = {}

END

# Reboot the Jupyterhub notebook
reboot