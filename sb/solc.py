import sb.cfg
import sb.debug
import solc_select.infrastructure.filesystem
import solc_select.models.versions
import solc_select.models.platforms
import solc_select.services.solc_service
from typing import Optional

SERVICE = None
ONLINE = None
AVAILABLE = None

SOLC_SELECT_DIR = sb.cfg.SOLC
ARTIFACTS_DIR = sb.cfg.SOLC / "artifacts"


def init_service():
    global SERVICE, ONLINE, AVAILABLE
    sb.debug.log("solc.init_service:")

    # patch constants
    solc_select.infrastructure.filesystem.SOLC_SELECT_DIR = SOLC_SELECT_DIR
    solc_select.infrastructure.filesystem.ARTIFACTS_DIR = ARTIFACTS_DIR

    linux_amd64 = solc_select.models.platforms.Platform("linux", "amd64")
    SERVICE = solc_select.services.solc_service.SolcService(linux_amd64)

    online = SERVICE.repository_matcher.get_all_available_versions()
    ONLINE = {str(v) for v in online.keys()}

    installed = {str(v) for v in SERVICE.get_installed_versions()}
    AVAILABLE = ONLINE | installed

    sb.debug.log(f"   {ONLINE=}\n   {installed=}")


def path(version: Optional[str]) -> Optional[str]:
    sb.debug.log(f"solc.path:\n   {version=}")

    solc_path = None
    if version:
        if SERVICE is None:
            init_service()
        installed = {str(v) for v in SERVICE.get_installed_versions()}
        if version in installed:
            solc_path = str(ARTIFACTS_DIR / f"solc-{version}" / f"solc-{version}")
        elif version in ONLINE:
            v = solc_select.models.versions.SolcVersion(version)
            success = SERVICE.artifact_manager.install_versions([v], silent=True)
            if success:
                solc_path = str(ARTIFACTS_DIR / f"solc-{version}" / f"solc-{version}")

    sb.debug.log(f"   {solc_path=}")
    return solc_path
