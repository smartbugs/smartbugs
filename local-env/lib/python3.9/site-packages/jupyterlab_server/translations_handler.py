# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

"""
Translation handler.
"""

import json
import traceback

import tornado
from tornado import gen

from .settings_utils import SchemaHandler
from .translation_utils import (
    get_language_pack,
    get_language_packs,
    is_valid_locale,
    translator,
)


class TranslationsHandler(SchemaHandler):
    @gen.coroutine
    @tornado.web.authenticated
    def get(self, locale=""):
        """
        Get installed language packs.

        Parameters
        ----------
        locale: str, optional
            If no locale is provided, it will list all the installed language packs.
            Default is `""`.
        """
        data, message = {}, ""
        try:
            if locale == "":
                data, message = get_language_packs(display_locale=self.get_current_locale())
            else:
                data, message = get_language_pack(locale)
                if data == {} and message == "":
                    if is_valid_locale(locale):
                        message = f"Language pack '{locale}' not installed!"
                    else:
                        message = f"Language pack '{locale}' not valid!"
                else:
                    # only change locale if the language pack is installed and valid
                    if is_valid_locale(locale):
                        translator.set_locale(locale)
        except Exception:
            message = traceback.format_exc()

        self.set_status(200)
        self.finish(json.dumps({"data": data, "message": message}))
