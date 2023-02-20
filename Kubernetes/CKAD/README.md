# Materials for CKAD exam

Highlights:
- Exam: https://www.cncf.io/certification/ckad/  
  - Linux Foundation gives 25% New Year discount (from 395$ - 31.01.2023) for CKAD during 1 week in January
  - after buying exam, you get 2 simulated exam sessions included: https://killer.sh/faq

## Training
- Kubernetes: https://www.udemy.com/course/certified-kubernetes-application-developer
- Helm: https://www.youtube.com/playlist?list=PLSwo-wAGP1b8svO5fbAr7ko2Buz6GuH1g

## Practice/Labs
- https://kodekloud.com/courses/kubernetes-challenges/
- https://liptanbiswas.com/tuts/ckad-practice-challenges/
- https://github.com/dgkanatsios/CKAD-exercises
- https://killercoda.com/killer-shell-ckad (free, but needs login)
- https://killercoda.com/killer-shell-cka (CKA, but worthy)

## YouTube videos
- API Fundamentals https://www.youtube.com/watch?v=_65Md2qar14

## Tips
- https://github.com/twajr/ckad-prep-notes

## Simulated exam
- lots of namespace switching
- lots of testing with curl

So, better prepare:
```sh
vim ~/.bashrc
alias kn='kubectl config set-context --current --namespace '
alias kb='kubectl run busybox-once --rm --restart=Never -it --image=busybox -- '
export O='--dry-run=client -o=yaml'
```