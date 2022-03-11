library(fgsea) # fast gene set enrichment analysis
library(HCAData) # loads a ton of other crap
library(destiny) # diffusion maps 

options("stringsAsFactors"=FALSE)
dataDir <- "~/Dropbox/TARGET_AML/TARGET_pAML_code"
markers <- read.csv(paste0(dataDir, "/Danaher_Popescu_selected_markers.csv")) 

byCellType <- split(markers, markers$CellType)
names(byCellType) # 

byLineage <- split(markers, markers$SubtypeOf)

bySource <- split(markers, markers$Source)

# merge with Volker's 
bernstein <- read.csv(paste0(dataDir, "/Bernstein_markers.dirty.csv"))
library(reshape2)
melted <- melt(bernstein, id.vars=NULL)
names(melted) <- c("CellType", "Gene")
melted$Source <- "Bernstein"
melted$SubtypeOf <- ifelse(grepl("like",melted$CellType),
                           "Leukemic", "Leukocytes")
melted$CellType <- as.character(melted$CellType) 
bernstein <- melted[, colnames(noDupes)] 

merged <- rbind(markers, bernstein)
dupes <- which(duplicated(merged$Gene))
noDupes <- merged[-dupes, ]
write.csv(noDupes, file=paste0(dataDir, "/markerGenes.noDupes.csv"))

