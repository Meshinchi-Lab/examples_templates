#Jenny Smith
#Oct 5th, 2020
#purpose: create an R package 

#https://usethis.r-lib.org/articles/articles/usethis-setup.html

# install.packages('git2r', type = 'source')
library(usethis)
library(devtools)
library(roxygen2)
library(git2r)



### environment set up 

# usethis::use_devtools()
usethis::edit_r_profile() #add in common documentation params - like author name

use_git_config(user.name = "Jennylsmith", 
               user.email = "jennyl.smith12@gmail.com")
use_git_config(core.editor = "nano")
?git_protocol()
git_sitrep()


#I have an older version of usethis? and re-installing is NOT updating it. 
#current v1.6.3 on rhino, but 1.9.0.900 on github?
# create_github_token()

credentials::set_github_pat()
# In the moment, I usually copy the PAT to
# the clipboard for the next step. 
# (I also store this PAT in my general password manager, for redundancy.)
# But the most useful place to store this PAT is in your Git credential store.


edit_r_environ()#less secure but lets start here as well if I messed up teh set_gihub_pat()
git_sitrep()


#https://happygitwithr.com/ssh-keys.html#create-an-ssh-key-pair
git2r::libgit2_features() 
#it looks like git2r on ubuntu will not support ssh protocol. 


# ?git2r::cred_ssh_key()
# ?use_git_credentials()
# git_credentials()


#check dependency for git2r ssh compatibility
#apt list --installed | grep -E "^libssh"
#libssh2-1/bionic,now 1.8.0-1 amd64 [installed,automatic]

#bash
#>ssh -T git@github.com
#Hi jennylsmith! You've successfully authenticated, but GitHub does not provide shell access.


## Start the package Setup 

#https://kbroman.org/AdvData/18_rpack_demo.html
#https://www.hvitfeldt.me/blog/usethis-workflow-for-package-development/
#https://laderast.github.io/2019/02/12/package-building-description-namespace/

library(available)
available("fusBreakpoint")

#these steps initialize only
pkgpath <- file.path(SCRIPTS,"RNAseq_Analysis/fusBreakpoint")
create_package(pkgpath)
use_git()
use_github()

#use git2r for commits/pushes afterwards
git2r::status()
git2r::add()
git2r::commit(repo=".", message="add stuff")
git2r::push()


