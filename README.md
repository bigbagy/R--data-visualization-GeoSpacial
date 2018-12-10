# geospatial-data-visualization
The R script file shows a geospatial visualization of median household income data for the United States from the 2006 to 2010 census. 
The data file contains zipcode, mean income, median income and population columns.
File is downloaded from University of Michigan's Institute for Social Research.

### workflow

1. download the data, select the relevant features and cleanup the data formats, 3 features are selected for visualization: household median income, household population, household Zip code
2. use Zip code to find geographical coordinates, cities and states (using zipcode package)
3. find the state average Median income by aggregating medium income data by different states
4. find the geographical coordinates and overall population for each state 
5. use goolgemap API to extract US map for visualization overlay
6. plot state median income with ggplot2 and overlay on Googlemap image
