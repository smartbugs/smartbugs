def _jupyter_server_extension_paths():
    # Locally import to avoid install errors.
    from .notebookapp import NotebookApp

    return [
        {
            'module': 'nbclassic.notebookapp',
            'app': NotebookApp,
            'name': 'jupyter-nbclassic'
        }
    ]
