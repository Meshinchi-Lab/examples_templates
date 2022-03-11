library(destiny) 

# train the mapping 
originalExpressionMatrix <- 
  read.table('../MOUSE_HSC_DIFF/normalisedCountsVariableGenes.txt', 
             header = T, row.names = 1)
logOriginalExpression <- log2(originalExpressionMatrix + 1)
dm <- DiffusionMap(t(logOriginalExpression), distance = "cosine", sigma = .16)
plot(dm, c(3,2,1), pch=20, col="grey")

# fit new data points 
newExpressionMatrix <- 
  read.table('..//MOUSE_HSC_DIFF/grover_expression.txt.gz', header = T)
newExpressionMatrix <- newExpressionMatrix[rownames(originalExpressionMatrix), ]
logNewExpression <- log2(newExpressionMatrix + 1)
dmProject <- dm_predict(dm, t(logNewExpression))
plot(dm, c(3,2,1), col = "grey", new_dcs=dmProject, pch=20, col_new = "red")

# interactive:
library(rgl) 

# bind both together
dmBoth <- rbind(eigenvectors(dm), dmProject)

# give the combined dataset sensible row names for coloring news 
rownames(dmBoth) <- c(paste0("new", 1:135), paste0("old", 1:1656))

# plot them both 
plot3d(dmBoth[,1], 
       dmBoth[,2], 
       dmBoth[,3], 
       type="s", 
       xlab="DC1", 
       ylab="DC2", 
       zlab="DC3",
       col=ifelse(substr(rownames(dmBoth), 1, 3) == "new", "red", "gray"), 
       radius=ifelse(substr(rownames(dmBoth), 1, 3) == "new", 0.002, 0.001))
