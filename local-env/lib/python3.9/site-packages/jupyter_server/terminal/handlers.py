# encoding: utf-8
"""Tornado handlers for the terminal emulator."""
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
import terminado
from tornado import web

from jupyter_server._tz import utcnow
from jupyter_server.auth.utils import warn_disabled_authorization

from ..base.handlers import JupyterHandler
from ..base.zmqhandlers import WebSocketMixin

AUTH_RESOURCE = "terminals"


class TermSocket(WebSocketMixin, JupyterHandler, terminado.TermSocket):

    auth_resource = AUTH_RESOURCE

    def origin_check(self):
        """Terminado adds redundant origin_check
        Tornado already calls check_origin, so don't do anything here.
        """
        return True

    def get(self, *args, **kwargs):
        user = self.current_user

        if not user:
            raise web.HTTPError(403)

        # authorize the user.
        if not self.authorizer:
            # Warn if there is not authorizer.
            warn_disabled_authorization()
        elif not self.authorizer.is_authorized(self, user, "execute", self.auth_resource):
            raise web.HTTPError(403)

        if not args[0] in self.term_manager.terminals:
            raise web.HTTPError(404)
        return super(TermSocket, self).get(*args, **kwargs)

    def on_message(self, message):
        super(TermSocket, self).on_message(message)
        self._update_activity()

    def write_message(self, message, binary=False):
        super(TermSocket, self).write_message(message, binary=binary)
        self._update_activity()

    def _update_activity(self):
        self.application.settings["terminal_last_activity"] = utcnow()
        # terminal may not be around on deletion/cull
        if self.term_name in self.terminal_manager.terminals:
            self.terminal_manager.terminals[self.term_name].last_activity = utcnow()
