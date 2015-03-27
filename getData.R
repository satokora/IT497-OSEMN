require("XML")
require("ggplot2")

file1<-"http://ieeexplore.ieee.org/gateway/ipsSearch.jsp?pys=2014&pye=2014&pu=IEEE&ctype=Journals&oa=1&hc=1000&rs=1"
discFile1<-"./data1.xml"
download.file(file1, discFile1, method = "wget",quiet = TRUE)
dat1_xml<-xmlInternalTreeParse(discFile1)
rootNode1<-xmlRoot(dat1_xml)

file2<-"http://ieeexplore.ieee.org/gateway/ipsSearch.jsp?pys=2014&pye=2014&pu=IEEE&ctype=Journals&oa=1&hc=1000&rs=1001"
discFile2<-"./data2.xml"
download.file(file2, discFile2, method = "wget",quiet = TRUE) 
dat2_xml<-xmlInternalTreeParse(discFile2)
rootNode2<-xmlRoot(dat2_xml)

append(rootNode1, rootNode2)
index<-getNodeSet(rootNode1, "//controlledterms//term")

sortedTable <- sort(table(xmlSApply(index, xmlValue)), TRUE)[1:5]

df <- data.frame(sortedTable)
colnames(df) <- c("Frequencies")

c1<-c("1.","2.","3.","4.","5.")

cols<-paste(c1, row.names(df), sep=" ")

g <- ggplot(df, aes(x=cols, y=Frequencies))
g + xlab("Top 5 Keywords")  + geom_bar(stat="identity")

