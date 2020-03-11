#!/usr/bin/env bash

sudo kubectl delete deployment webapp-deployment 
sudo kubectl delete service webapp-service
sudo kubectl delete deployment checker-deployment
sudo kubectl delete service checker-service