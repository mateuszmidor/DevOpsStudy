#!/usr/bin/env bash

kubectl delete deployment webapp-deployment 
kubectl delete service webapp-service
kubectl delete deployment checker-deployment
kubectl delete service checker-service