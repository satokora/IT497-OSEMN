##############################
# OSEMN data collecting part #
#    Author: Satoko Kora     #
##############################


## import packages
require("XML")
require("ggplot2")

## Retrieving data of open-access academic journals published by IEEE in 2014
## Total number of journals is around 1200 as of Mar 27 2015, so data is retrived in twice

## Retrieve first 600 journals
file1<-"http://ieeexplore.ieee.org/gateway/ipsSearch.jsp?pys=2014&pye=2014&pu=IEEE&ctype=Journals&oa=1&hc=600&rs=1"

## Export data to XML file first and load it into memory
discFile1<-"./data1.xml"
download.file(file1, discFile1, method = "wget",quiet = TRUE)
dat1_xml<-xmlInternalTreeParse(discFile1)
rootNode1<-xmlRoot(dat1_xml)

## Retrieve next 600 journals
file2<-"http://ieeexplore.ieee.org/gateway/ipsSearch.jsp?pys=2014&pye=2014&pu=IEEE&ctype=Journals&oa=1&hc=1000&rs=601"

## Export data to XML file first and load it into memory
discFile2<-"./data2.xml"
download.file(file2, discFile2, method = "wget",quiet = TRUE) 
dat2_xml<-xmlInternalTreeParse(discFile2)
rootNode2<-xmlRoot(dat2_xml)

## Combining two parts of data into one
append(rootNode1, rootNode2)

## Retrieve Controlled Index Terms section of journals
index<-getNodeSet(rootNode1, "//controlledterms//term")

## Count frequencies of keywords and get top 5 keywords
sortedTable <- sort(table(xmlSApply(index, xmlValue)), TRUE)[1:5]

## Make a bar chart based on the data
df <- data.frame(sortedTable)

### Labels for the graph 
colnames(df) <- c("Frequencies")
c1<-c("1.","2.","3.","4.","5.")
cols<-paste(c1, row.names(df), sep=" ")

g <- ggplot(df, aes(x=cols, y=Frequencies))
g + xlab("Top 5 Keywords")  + geom_bar(stat="identity")

