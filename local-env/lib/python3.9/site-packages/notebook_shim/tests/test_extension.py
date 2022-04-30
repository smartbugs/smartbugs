
import io
import logging
import pytest

from traitlets import default
from .mockextension import MockExtensionApp
from notebook_shim import shim


@pytest.fixture
def extapp_log():
    """An io stream with the NotebookApp's logging output"""
    stream = io.StringIO()
    return stream


@pytest.fixture(autouse=True)
def extapp_logcapture(monkeypatch, extapp_log):
    """"""
    @default('log')
    def _log_default(self):
        """Start logging for this application.
        The default is to log to stderr using a StreamHandler, if no default
        handler already exists.  The log level starts at logging.WARN, but this
        can be adjusted by setting the ``log_level`` attribute.
        """
        log = super(self.__class__, self)._log_default()
        _log_handler = logging.StreamHandler(extapp_log)
        _log_formatter = self._log_formatter_cls(
            fmt=self.log_format,
            datefmt=self.log_datefmt
        )
        _log_handler.setFormatter(_log_formatter)
        log.addHandler(_log_handler)
        return log

    monkeypatch.setattr(MockExtensionApp, '_log_default', _log_default)
    return _log_default


@pytest.fixture
def jp_server_config():
    return {
        "ServerApp": {
            "jpserver_extensions": {
                "notebook_shim": True,
                "notebook_shim.tests.mockextension": True
            }
        }
    }


@pytest.fixture
def extensionapp(jp_serverapp):
    return jp_serverapp.extension_manager.extension_points["mockextension"].app


def list_test_params(param_input):
    """"""
    params = []
    for test in param_input:
        name, value = test[0], test[1]
        option = (
            '--MockExtensionApp.'
            '{name}={value}'
            .format(name=name, value=value)
        )
        params.append([[option], name, value])
    return params


@pytest.mark.parametrize(
    'jp_argv,trait_name,trait_value',
    list_test_params([
        ('enable_mathjax', False)
    ])
)
def test_EXTAPP_AND_NBAPP_SHIM_MSG(
    extensionapp,
    extapp_log,
    jp_argv,
    trait_name,
    trait_value
):
    log = extapp_log.getvalue()
    # Verify a shim warning appeared.
    log_msg = shim.EXTAPP_AND_NBAPP_SHIM_MSG(trait_name, 'MockExtensionApp')
    assert log_msg in log
    # Verify the trait was updated.
    assert getattr(extensionapp, trait_name) == trait_value


@pytest.mark.parametrize(
    'jp_argv,trait_name,trait_value',
    list_test_params([
        ('allow_origin', ''),
        ('allow_origin_pat', ''),
    ])
)
def test_EXTAPP_AND_SVAPP_SHIM_MSG(
    extensionapp,
    extapp_log,
    jp_argv,
    trait_name,
    trait_value
):
    log = extapp_log.getvalue()
    # Verify a shim warning appeared.
    log_msg = shim.EXTAPP_AND_SVAPP_SHIM_MSG(trait_name, 'MockExtensionApp')
    assert log_msg in log
    # Verify the trait was updated.
    assert getattr(extensionapp, trait_name) == trait_value


@pytest.mark.parametrize(
    'jp_argv,trait_name,trait_value',
    list_test_params([
        ('jinja_environment_options', {}),
        ('jinja_template_vars', {}),
        ('extra_template_paths', []),
        ('quit_button', True),
    ])
)
def test_NOT_EXTAPP_NBAPP_AND_SVAPP_SHIM_MSG(
    extensionapp,
    extapp_log,
    jp_argv,
    trait_name,
    trait_value
):
    log = extapp_log.getvalue()
    # Verify a shim warning appeared.
    log_msg = shim.NOT_EXTAPP_NBAPP_AND_SVAPP_SHIM_MSG(trait_name, 'MockExtensionApp')
    assert log_msg in log
    # Verify the trait was updated.
    assert getattr(extensionapp.serverapp, trait_name) == trait_value


@pytest.mark.parametrize(
    'jp_argv,trait_name,trait_value',
    list_test_params([
        ('allow_credentials', False),
    ])
)
def test_EXTAPP_TO_SVAPP_SHIM_MSG(
    extensionapp,
    extapp_log,
    jp_argv,
    trait_name,
    trait_value
):
    log = extapp_log.getvalue()
    # Verify a shim warning appeared.
    log_msg = shim.EXTAPP_TO_SVAPP_SHIM_MSG(trait_name, 'MockExtensionApp')
    assert log_msg in log
    # Verify the trait was updated.
    assert getattr(extensionapp.serverapp, trait_name) == trait_value


@pytest.mark.parametrize(
    'jp_argv,trait_name,trait_value',
    list_test_params([
        ('mathjax_config', 'TEST'),
        ('mathjax_url', 'TEST')
    ])
)
def test_EXTAPP_TO_NBAPP_SHIM_MSG(
    extensionapp,
    extapp_log,
    jp_argv,
    trait_name,
    trait_value
):
    log = extapp_log.getvalue()
    # Verify a shim warning appeared.
    log_msg = shim.EXTAPP_TO_NBAPP_SHIM_MSG(trait_name, 'MockExtensionApp')
    assert log_msg in log
