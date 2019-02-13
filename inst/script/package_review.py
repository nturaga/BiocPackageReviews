import subprocess
import sys
import os


class PackageReview(object):

    def __init__(self, github_link):
        """Initialize package review class."""
        self.github_link = github_link
        self.packge_review_dir = "~/Documents/bioc_package_reviews"
        self.package_name = github_link.split("/")[-1].replace(".git", "")
        self.package_dir = os.path.join(self.package_review_dir,
                                        self.package_name)

    def git_clone_package(self):
        """Clone packge from github."""
        cmd = ['git', 'clone', self.github_link]
        subprocess.check_call(cmd, cwd=self.package_review_dir)
        return

    def run_r_cmd_build(self):
        """Run R-dev CMD build package."""
        cmd = ['R-dev', 'CMD', 'build', self.package_name]
        cwd = self.package_review_dir
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, cwd=cwd)
        out, err = proc.communicate()
        # Find .tar.gz file, and assign to self.package_tar_ball
        return

    def run_r_cmd_install(self):
        """Run R-dev CMD INSTALL package."""
        cmd = ['R-dev', 'CMD', 'INSALL', self.package_tar_ball]
        cwd = self.package_review_dir
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, cwd=cwd)
        out, err = proc.communicate()
        return

    def run_r_cmd_stangle(self):
        """Run R-dev CMD Stangle vignette."""
        self.find_vignette()
        cmd = ['R-dev', 'CMD', 'Stangle', self.vignette]
        cwd = self.vigentte_dir
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, cwd=cwd)
        out, err = proc.communicate()
        return

    def find_vignette(self):
        """Find vignette."""
        file_types = ['Rmd', 'Rnw']
        self.vigentte_dir = os.path.join(self.package_dir, 'vignettes')
        for item in os.listdir(self.vigentte_dir):
            ext = item.split(".")[-1]
            if ext in file_types:
                self.vignette = os.path.join(self.vigentte_dir, item)
        return


class MakeMarkdown(object):

    def __init__(self, markdownfile):
        self.markdownfile = markdownfile

    def template(self):
        """Template for markdown file."""
        return


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: `python package_review.py <github_link>`')
    if len(sys.argv) == 2:
        github_link = sys.argv[1]
        review = PackageReview(github_link)
        print('Please check %s_review.md' % review.package_name)
