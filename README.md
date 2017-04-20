# What is scenarios-finder
Its a simple tool to track the automation progress for e.g. 
1. To know How many tests are automated in last week or last month 
2. To know how many scenarios are tagged as todo, so that we can start automating those
3. To know how many scenarios are tagged as manual, so that we can get an idea of how much manual testing needed


#How do we run it
Its very simple to rn, you need to just execute the following command :
> ruby scenarios_finder.rb

it will ask for the local repo location which you can provide like
../radio/radio-v2-cucumber-tests

and press enter

#How to see the results
You will find a new file created with name as : scenarios.html
Simply opne the file and you will see two types of reporting :
1. Each and every file and list of tags found
2. At the end of the report you will find the final report for the provided repo
