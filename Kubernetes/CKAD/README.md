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
- https://editor.cilium.io/ (Netowork Policy lab)
- https://tanzu.vmware.com/developer/blog/ckad-practice-questions-sept-21/
- https://k21academy.com/docker-kubernetes/cka-ckad-exam-questions-answers/
- https://codeburst.io/kubernetes-ckad-weekly-challenges-overview-and-tips-7282b36a2681
- https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552

## YouTube videos
- API Fundamentals https://www.youtube.com/watch?v=_65Md2qar14

## Tips
- https://github.com/twajr/ckad-prep-notes
- https://kavinduchamiran.medium.com/my-two-cents-on-passing-ckad-in-2022-ffbb7f1c65be

## Simulated exam
- lots of namespace switching
- lots of testing with curl
- multitab terminal available
- multidesktop linux!

So, better prepare ~/.bashrc:
```sh
alias kn='kubectl config set-context --current --namespace '
alias kb='kubectl run busybox-once --rm --restart=Never -it --image=busybox -- '
alias ka='kubectl apply -f '
alias kr='kubectl replace --force --grace-period=0 -f '
alias l=less
alias ke='kubectl explain --recursive '# usage: ke pod.spec.volumes | l
export O='--dry-run=client -o=yaml'
export N='--grace-period=0 --force'
```

And ~/.vimrc:
```vim
syntax on
set number
set shiftwidth=2
set tabstop=2
set expandtab
autocmd FileType yaml setlocal ai "enable auto-indent in YAML files
```