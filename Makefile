# GIT functions

push-all:
	git add .
	git commit -m 'edits'
	git push origin -u main

push:
	git push origin -u main

commit:
	git add .
	git commit
	git push origin -u main