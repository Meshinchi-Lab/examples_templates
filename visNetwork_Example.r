
library(visNetwork)





nodesA <- data.frame(id = 1:10, 
                    label = paste("Node", 1:10),                                 # add labels on nodes
                    group = c("GrA", "GrB"),                                     # add groups on nodes 
                    value = 1:10,                                                # size adding value
                    shape = c("square", "triangle", "box", "circle", "dot", "star",
                              "ellipse", "database", "text", "diamond"),                   # control shape of nodes
                    title = paste0("<p><b>", 1:10,"</b><br>Node !</p>"),         # tooltip (html or character)
                    color = c("darkred", "grey", "orange", "darkblue", "purple"),# color
                    shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE)) 

head(nodesA)
# ?visNodes

# set.seed(2019)
edgesB <- data.frame(from = sample(1:10, 8),
                    to = sample(1:10, 8),
                    label = paste("Edge", 1:8),                                 # add labels on edges
                    length = c(100,500),                                        # length
                    arrows = c("to", "from", "middle", "middle;to"),            # arrows
                    dashes = c(TRUE, FALSE),                                    # dashes
                    title = paste("Edge", 1:8),                                 # tooltip (html or character)
                    smooth = c(FALSE, TRUE),                                    # smooth
                    shadow = c(FALSE, TRUE, FALSE, TRUE))                       # shadow
head(edgesB)
# ?visEdges

obj <- visNetwork(nodesA, edgesB, width = "100%")

visOptions(obj, width = NULL, height = NULL,
           highlightNearest = TRUE, 
           nodesIdSelection = list("useLabels"=TRUE),
           selectedBy = NULL, collapse = FALSE, autoResize = NULL,
           clickToUse = NULL, manipulation = NULL)

nodes <- data.frame(id = 1:5, 
                    label = paste("Node", 1:5),
                    # title=paste("Node",1:5),
                    title = paste0("<p><b>", 1:5,"</b><br>Node !</p>"),
                    group = c(rep("A", 2),rep("B", 3)))

edges <- data.frame(from = c(2,5,3,3),
                    label = paste("Edge", 1:4),
                    title = paste("Edge", 1:4),
                    to = c(1,2,4,2))

visNetwork(nodes, edges, width = "100%")
