#!/bin/bash
  echo on
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/04-open_data-projects.csv.gz
  gunzip 04-open_data-projects.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/01-open_data-donations.csv.gz
  gunzip 01-open_data-donations.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/03-open_data-giftcards.csv.gz
  gunzip 03-open_data-giftcards.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/05-open_data-resources.csv.gz
  gunzip 05-open_data-resources.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/02-open_data-essays.csv.gz
  gunzip 02-open_data-essays.csv.gz
  wget http://developer.donorschoose.org/the-data/data-schema/donorschoose-org-1apr2011-v1-load-script.sh?attredirects=0&d=1
  wget http://developer.donorschoose.org/the-data/data-schema/donorschoose-org-1apr2011-v1-load-script.sql?attredirects=0&d=1
  wget http://developer.donorschoose.org/the-data/data-schema/donorschoose-org-1apr2011-v1-normalize-script.sql?attredirects=0&d=1
  echo off