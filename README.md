#Event_Manager

This program parses .csv database, cleans records, creates and writes to new files, and calculates peak hour and day with the highest number of registrants in a dummy data set.

###The techniques practiced:

* File input and output
* Reading data from CSV files
* String manipulation
* Accessing Sunlight’s Congressional API through the Sunlight Congress gem
* Using ERB for templating

###Sample output:

Data pulled from  event_attendees.csv

```
PEAK HOURS
-----------
Hour: 16 has 3 registers (15.8)%
Hour: 13 has 3 registers (15.8)%
Hour: 20 has 2 registers (10.5)%
-----------

PEAK DAYS
-----------
Wednesday  has 7  registers (36.8)%
Thursday   has 5  registers (26.3)%
Sunday     has 4  registers (21.1)%
-----------
``` 
View the assignment at [Jumpstart Labs](http://tutorials.jumpstartlab.com/projects/eventmanager.html)
