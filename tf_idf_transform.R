#Scott Furlan 
#7/27/20 

#Purpose: TF-IDF transformation of counts matrices

tf_idf_transform <- function(input, method=1, verbose=T){
  if(class(input)=="cell_data_set"){
    mat<-exprs(input)
  }else{
    mat<-input
  }
  rn <- rownames(mat)
  row_sums<-Matrix::rowSums(mat)
  nz<-which(row_sums>0)
  mat <- mat[nz,]
  row_sums <- row_sums[nz]
  col_sums <- Matrix::colSums(mat)
  
  #column normalize
  mat <- t(t(mat)/col_sums)
  
  
  if (method == 1) {
    #Adapted from Casanovich et al.
    if(verbose) message("Computing Inverse Document Frequency")
    idf   <- as(log(1 + ncol(mat) / row_sums), "sparseVector")
    if(verbose) message("Computing TF-IDF Matrix")
    mat <- as(Matrix::Diagonal(x = as.vector(idf)), "sparseMatrix") %*% 
      mat
  }
  else if (method == 2) {
    #Adapted from Stuart et al.
    if(verbose) message("Computing Inverse Document Frequency")
    idf   <- as( ncol(mat) / row_sums, "sparseVector")
    if(verbose) message("Computing TF-IDF Matrix")
    mat <- as(Matrix::Diagonal(x = as.vector(idf)), "sparseMatrix") %*% 
      mat
    mat@x <- log(mat@x * scale_to + 1)
  }else if (method == 3) {
    mat@x <- log(mat@x + 1)
    if(verbose) message("Computing Inverse Document Frequency")
    idf <- as(log(1 + ncol(mat) /row_sums), "sparseVector")
    if(verbose) message("Computing TF-IDF Matrix")
    mat <- as(Matrix::Diagonal(x = as.vector(idf)), "sparseMatrix") %*% 
      mat
  }else {
    stop("LSIMethod unrecognized please select valid method!")
  }
  rownames(mat) <- rn
  if(class(input)=="cell_data_set"){
    input@assays$data$counts<-mat
    return(input)
  }else{
    return(mat)
  }
}
