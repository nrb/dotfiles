from fabric.api import run
from fabric.api import env
from fabric.utils import abort
from fabric.contrib.files import exists

dotfiles_base = 'https://svn.sixfeetup.com/svn/private/developers/dotfiles/branches/nolan'
# TODO: change to your branch here
env.dotfiles = '%s/trunk' % dotfiles_base


def push_dotfiles():
    """Push my dotfiles to a specific server

    $ fab -H host1,host2 push_dotfiles
    """
    # run this to expose potential issues with the machine like
    # bash not being in /bin/bash
    run("echo $HOME")
    if not exists("$HOME"):
        abort("You do not appear to have a home directory")
    if exists(".dotfiles"):
        abort("The .dotfiles directory already exists")
    run('svn co %s .dotfiles' % env.dotfiles)
    run('.dotfiles/create_links.sh remove')
    run('.dotfiles/create_links.sh')


def remove_dotfiles(ignore=None):
    """Remove my dotfiles from a specific server
    """
    # run this to expose potential issues with the machine like
    # bash not being in /bin/bash
    run("echo $HOME")
    if not exists("$HOME"):
        abort("You do not appear to have a home directory")
    if not exists(".dotfiles"):
        abort("The .dotfiles directory does not exist")
    output = run("svn st .dotfiles")
    msg = "There are local changes, commit or revert before continuing"
    if output and ignore is None:
        abort(msg)
    run('svn up .dotfiles')
    run('.dotfiles/create_links.sh cleanup')
    run('rm -rf .dotfiles')
