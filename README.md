
# Price prediction and analysis application for used cars

<!-- badges: start -->
<!-- badges: end -->

https://www.kaggle.com/hansjoerg/glmnet-xgboost-and-svm-using-tidymodels

##Introduction

Herein, documentation and code is provided for an ongoing project of mine. The  need and idea for which came from my friend, whom I decided to help with.

The goal of this progect is to analize data and get some valuable insights on cars listed for sale on two most popular sales car websites in Lithuania. As well as implement and learn new practices of handling panel data in R, incorporate tidy principles, and use functional programing and to make progect robust. 

##Technologies used

Project is created with:
* Lorem version: 12.3
* Ipsum version: 2.33
* Ament library version: 999


Data is scraped of the mentioned websites using rvest package, than tidied and procecced with help of latest tidyverse packages such as stringr, tidyr, purrr(for iterations)...
Pakage here is used to help esure robustness of code and file paths outside in the project.

I spent some time on data pre-processing and feature engineering as well as on trying different models and tuning their parameters.

As of this moment, mentioned websites are scraped each day for adds, gatherd data is cleaned and combined in a full data set into data/tidy/combined.

Other users may be interested in this project, for example, because everything was done in the tidymodels ecosystem using packages such as recipes or parsnip. I especially liked the tune package for parameter tuning via grid search or Bayesian optimization.

because everything was done in the tidymodels ecosystem using packages such as recipes or parsnip. I especially liked the tune package for parameter tuning via grid search or Bayesian optimization.


##Launch


## Setup
To run this project, install it locally using npm:

```
$ cd ../lorem
$ npm install
$ npm start
```



2 Setup
2.1 Load Packages


This is an ongoing progect of mine the  need and idea for whicht came from my friend, whom I decided to help with.

The goal of this progect is to analize data and get some valuable insights on cars listed for sale 
from data, as well as implement and learn new practices of handling panel data in R, incorporate tidy principles, and use functional programing and to make progect robust.
that is 
gathered(scraped) from two most popular sales car websites in Lithuania.

Data is scraped using rvest package, than tidied and procecced with help of latest tidyverse packages such as stringr, tidyr, purrr(for iterations)...
Pakage here is used to help esure robustness of code and file paths outside in the project.

As of this moment, mentioned websites are scraped each day for adds, gatherd data is cleaned and combined in a full data set into data/tidy/combined

EDA and analysis of gathered data is represented in 01_exploration/eda.html
panelr for Panel data
as a special step for EDA correlationfunnel:: was used in order to Speeds Up Exploratory Data Analysis and Improves Feature Selection


2.2 Import Data

3 Data Pre-Processing and Feature Engineering
I spent some time on pre-processing the data, and this was to some extend inspired by the kernels of Erik Bruin, Bart Boerman, and Zong Tseng. The steps I took were either done while importing the data (see above) or in a recipe. Furthermore, I removed a few outliers. Herein, I decided to separate code and documentation a little bit: This section explains the steps I took, and Section 4 contains the code.

3.1 Outcome
The outcome variable is skewed and was log-transformed in the recipe using step_log().


3.2 Feature Engineering: New Variables
I created a few new variables, for example:

The age of the house is the time between the last remodel and sale.
The age2 of the house is the time between construction and sale.
The variable alley encodes whether the house has alley access or not.
I computed the total number of bathrooms as the sum of the bathrooms above and below grade (including “half” bathrooms multiplied by 0.5).
The variable RemodAdd encodes whether a house was remodeled or not.
The variable TotalSF calculate the size of the house in square feet above and below grade.
I computed the average room size.
The porch size in SF was calculated as the sum of the individual porches.
These variables were added in the recipe using step_mutate().










# Project Name
> Here goes your awesome project description!

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Inspiration](#inspiration)
* [Contact](#contact)

## General info
Add more general information about project. What the purpose of the project is? Motivation?

## Screenshots
![Example screenshot](./img/screenshot.png)

## Technologies
* Tech 1 - version 1.0
* Tech 2 - version 2.0
* Tech 3 - version 3.0

## Setup
Describe how to install / setup your local environement / add link to demo version.

## Code Examples
Show examples of usage:
`put-your-code-here`

## Features
List of features ready and TODOs for future development
* Awesome feature 1
* Awesome feature 2
* Awesome feature 3

To-do list:
* Wow improvement to be done 1
* Wow improvement to be done 2

## Status
Project is: _in progress_, _finished_, _no longer continue_ and why?

## Inspiration
Add here credits. Project inspired by..., based on...

## Contact
Created by [@flynerdpl](https://www.flynerd.pl/) - feel free to contact me!


