
library(XML)
library(magrittr)
library(dplyr)
library(tidyr)
library(tibble)
library(plyr)



# http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_predictions/hsa-miR-1/TP53
# http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_confirmed/hsa-miR-1/ABHD11

#API for predictions
api <- "http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_predictions"

query <- eval(paste(api,"hsa-miR-1","TP53", sep="/"))
tmp <- "http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_predictions/hsa-miR-1/TP53"

#API for experimentally confirmed interactions. 
api.exp <- "http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_confirmed"
query2 <- eval(paste(api.exp,"hsa-miR-1","ABHD11", sep="/"))


xml.file=xmlParse(query)


xmlfile=xmlParse("~/Downloads/pubmed_sample.xml")
mirGate.top = xmlRoot(xml.file)


xmltop = xmlRoot(xmlfile) #gives content of root

class(xmltop)#"XMLInternalElementNode" "XMLInternalNode" "XMLAbstractNode"
xmlName(xmltop) #give name of node, PubmedArticleSet
xmlSize(xmltop) #how many children in node, 19
xmlName(xmltop[[1]]) #name of root's children

xmlName(mirGate.top) #mirGate
xmlSize(mirGate.top) #2

names(mirGate.top)
# schema   search 
# "schema" "search" 


xmlSize(xmltop[[1]]) #number of nodes in each child
xmlSApply(xmltop[[1]], xmlName) #name(s)
xmlSApply(xmltop[[1]], xmlAttrs) #attribute(s)
xmlSApply(xmltop[[1]], xmlSize) #size


names(mirGate.top[[2]]) #results 
xmlSApply(mirGate.top, xmlName) #schema, search 
xmlSApply(mirGate.top[[2]], xmlAttrs)
xmlSApply(mirGate.top[[2]], xmlSize)
children <- xmlChildren(mirGate.top[[2]], 1)


Madhu2012=ldply(xmlToList("~/Downloads/pubmed_sample.xml"), data.frame) #completes with errors: "row names were found from a short variable and have been discarded"
View(Madhu2012) #for easy checking that the data is properly formatted
Madhu2012.Clean=Madhu2012[Madhu2012[25]=='Y',] #gets rid of duplicated rows


#first result
mirGate.top[[2]][[1]][[1]] #ENST00000269305
#second results 
mirGate.top[[2]][[1]][[2]] #ENST00000445888

######################################

searchRes <- xmlToList(mirGate.top[["search"]][["results"]])
attrs.idx <-  lapply(searchRes, function(x)  grepl("attrs", names(x)))
searchDf <- mapply( function(x,y) x[!y], searchRes, attrs.idx, SIMPLIFY = TRUE)
colnames(searchDf) <- paste0("result", seq(1,ncol(searchDf)))


attrs <-  data.frame(sapply(searchRes, function(x)  x[grep("attrs", names(x))]))
colnames(attrs) <- colnames(searchDf)

searchDf <- rbind(searchDf, attrs) %>%
  rownames_to_column() %>%
  filter(rowname != "miRNA1") %>%
  gather(var, value, -rowname) %>%
  spread(rowname, value) %>%
  select(input_miRNA=miRNA, input_gene=HGNC, everything())



#######################################

MirGate.Pred.db <- function(miRNA.ID, GeneSymbol){
  api <- "http://mirgate.bioinfo.cnio.es/ResT/API/human/miRNA_gene_predictions"
  query <- eval(paste(api,miRNA.ID,GeneSymbol, sep="/"))
  
  #get the XML file from the query results.
  xml.file=xmlParse(query)
  top=xmlRoot(xml.file)
  
  #Creat a list of the query results. 
  searchRes <- xmlToList(top[["search"]][["results"]])
  attrs.idx <-  lapply(searchRes, function(x)  grepl("attrs", names(x)))
  
  #subset out the attributes row. Causes duplication of entries. 
  searchDf <- mapply( function(x,y) x[!y], searchRes, attrs.idx, SIMPLIFY = TRUE)
  searchDf <- data.frame(apply(searchDf, 2, unlist)) #needed because mapply returns a matrix of lists. 
  
  #unique colnames for the dataframe. 
  colnames(searchDf) <- paste0("result", seq(1,ncol(searchDf)))
  
  #extract the attributes from the query. 
  attrs <-  data.frame(sapply(searchRes, function(x)  x[grep("attrs", names(x))]))
  colnames(attrs) <- colnames(searchDf)
  
  #Clean up the dataframe. 
  searchDf <- rbind(searchDf, attrs) %>% #Add back in the attributes as a row.
    rownames_to_column() %>% #rownames to a column
    filter(rowname != "miRNA1") %>% #remove repetitive row. 
    gather(var, value, -rowname) %>% #gather and spread to transpose df 
    spread(rowname, value) %>%
    select(input_miRNA=miRNA, input_gene=HGNC, method, agreement_value, everything())
  
    return(searchDf)  
}

  
setwd("~/RNA_seq_Analysis/2017.02.15_CBF-GLIS_DEG/CBFGLISvsOtherAML/1031/")

DEGs <- read.csv()






