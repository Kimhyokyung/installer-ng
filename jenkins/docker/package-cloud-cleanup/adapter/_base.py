# coding:utf-8
import itertools
import logging
import posixpath

from ._constant import API_URL
from adapter.exception import PackageDeletionFailed


class BaseRepoAdapter(object):
    def __init__(self, user, repo, api_session, client_session, packages_to_clean, versions_to_keep):
        self.user = user
        self.repo = repo
        self.api_session = api_session
        self.client_session = client_session

        self.packages_to_clean = packages_to_clean
        self.versions_to_keep = versions_to_keep

    def clean(self):
        has_erred = False

        for platform, arch in itertools.product(self._get_platforms(), self._get_archs()):
            logger = logging.getLogger(".".join([self.repo, platform, arch]))
            logger.debug("Process: %s/%s/%s", self.repo, platform, arch)

            all_packages = self._fetch_package_list(platform, arch)

            for needle in self.packages_to_clean:
                packages_to_delete = self._get_packages_to_delete(logger, needle, all_packages)

                for pkg in packages_to_delete:
                    try:
                        self._delete_package(logger, platform, pkg)
                    except PackageDeletionFailed:
                        has_erred = True

        return has_erred

    # Utility

    def _get_packages_to_delete(self, logger, needle, all_pkgs):
        pkgs = [pkg for pkg in all_pkgs if self._extract_pkg_name(pkg) == needle]
        pkgs.sort(key=self._extract_orderable_version, reverse=True)

        logger.info("%s: found %s package(s)", needle, len(pkgs))
        logger.debug("versions: %s", [self._extract_orderable_version(p) for p in pkgs])
        if len(pkgs) <= self.versions_to_keep:
            return []

        return pkgs[self.versions_to_keep:]

    def _delete_package(self, logger, platform, pkg):
        logger.warning("%s: deleting %s", self._extract_pkg_name(pkg), self._extract_pretty_name(pkg))
        del_file = posixpath.basename(self._extract_file_name(pkg))
        res = self.api_session.delete("/".join([API_URL, "repos", self.user, self.repo, platform, del_file]))
        if res.status_code >= 400 or "error" in res.json():
            logger.error("%s: failed to delete %s (%s)", self._extract_pkg_name(pkg), del_file, res.text)
            raise PackageDeletionFailed()

    def _orderable_version(self, scalr_version, build):
        # scalr_version is a list representing the version of Scalr that's included in the package: ['7', '7', '2']
        # build is either: - a build number, like 'bxx-1' (debian) or 'bxxx' (el); or - a date, for nightlies
        if 'b' in build:
            build = build.replace('b', '').replace('-1', '')
            build = int(build)
        else:
            # it's a date, we want it to be always smaller than a build number since it is the old versioning scheme
            build = float('0.' + build)
        scalr_version = tuple(int(i) for i in scalr_version)
        return scalr_version, build

    # Implementation Specific

    def _fetch_package_list(self, platform, arch):
        raise NotImplementedError()

    def _extract_pkg_name(self, pkg):
        raise NotImplementedError()

    def _extract_file_name(self, pkg):
        raise NotImplementedError()

    def _extract_orderable_version(self, pkg):
        raise NotImplementedError()

    def _extract_pretty_name(self, pkg):
        return posixpath.basename(self._extract_file_name(pkg))

    def _get_platforms(self):
        raise NotImplementedError()

    def _get_archs(self):
        raise NotImplementedError()
