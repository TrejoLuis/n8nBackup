#! /bin/bash
# validate if "automaticBackup" branch exists otherwise create it
if [[ $(git branch | grep -q 'automaticBackup') ]]; then
  # create branch
  git branch -m automaticBackup;
fi
# switch to branch if needed
if [[ $(git branch --show-current) != "automaticBackup" ]]; then
  git switch automaticBackup;
fi
# already in automaticBackup branch
docker run --rm --volumes-from n8n -v $(pwd):/backup busybox tar cvf /backup/backup.tar /home/node/.n8n;
tar -xf backup.tar;
rm -f backup.tar;
# n8n files
git add home;
git commit -m "chore: backup $(date "+%Y-%m-%d")";
git push -u origin automaticBackup;
